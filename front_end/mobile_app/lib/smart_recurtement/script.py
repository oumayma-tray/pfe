import sys
import os
import PyPDF2
import spacy
from gensim.models import Word2Vec
from gensim.models.phrases import Phrases, Phraser
from spacy.matcher import PhraseMatcher

# List of common skills
common_skills = [
    "machine_learning", "data_science", "software_development", "python", "java", "c++",
    "tensorflow", "keras", "pandas", "numpy", "matplotlib", "scikit_learn", "git", "docker",
    "agile_methodologies", "sql", "javascript", "html", "css", "react", "node.js", "aws", 
    "azure", "linux", "unix", "shell_scripting", "hadoop", "spark", "deep_learning"
]

# Function to extract text from PDF
def extract_text_from_pdf(pdf_path):
    with open(pdf_path, "rb") as file:
        pdf_reader = PyPDF2.PdfReader(file)
        text = ""
        for page_num in range(len(pdf_reader.pages)):
            text += pdf_reader.pages[page_num].extract_text()
    return text

# Function to preprocess the text
def preprocess_text(text):
    nlp = spacy.load('en_core_web_sm')
    doc = nlp(text.lower())
    tokens = [token.lemma_ for token in doc if not token.is_stop and token.is_alpha]
    return tokens

# Function to match skills
def match_skills(cv_text, skill_keywords, model):
    nlp = spacy.load('en_core_web_sm')
    matcher = PhraseMatcher(nlp.vocab)
    patterns = [nlp.make_doc(skill.replace('_', ' ')) for skill in skill_keywords]
    matcher.add("SKILLS", patterns)
    
    doc = nlp(" ".join(cv_text))
    matches = matcher(doc)
    score = 0
    for match_id, start, end in matches:
        span = doc[start:end]
        try:
            similar_words = model.wv.most_similar("_".join(span.text.split()), topn=5)
            score += len(similar_words)
        except KeyError:
            continue
    return score

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: script.py <pdf_path> <skills>")
        sys.exit(1)

    pdf_path = sys.argv[1]
    skills = sys.argv[2].split(',')

    print(f"Processing PDF: {pdf_path}")
    
    try:
        text = extract_text_from_pdf(pdf_path)
        print(f"Extracted Text: {text[:1000]}...")  # Print first 1000 characters for verification
    except Exception as e:
        print(f"Error extracting text from PDF: {e}")
        sys.exit(1)

    processed_text = preprocess_text(text)
    print(f"Processed Text: {processed_text}")

    phrases = Phrases([processed_text], min_count=1, threshold=1)
    bigram = Phraser(phrases)
    bigram_text = bigram[processed_text]

    print(f"Bigram Text: {bigram_text}")

    model = Word2Vec(sentences=[bigram_text], vector_size=100, window=5, min_count=1, workers=4)
    
    score = match_skills(bigram_text, skills, model)
    print(f"Skill Match Score: {score}")

    print(score)
