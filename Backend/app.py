from flask import Flask, jsonify, request
from flask_cors import CORS
import random

app = Flask(__name__)
CORS(app)

# Fake database (you can replace these later)
PLACES = {
    "Food": [
        {"name": "Vandy's BBQ", "rating": 4.9, "distance": "0.5 mi"},
        {"name": "El Sombrero", "rating": 4.7, "distance": "1.1 mi"},
    ],
    "Activities": [
        {"name": "RAC Sports Complex", "rating": 4.8, "distance": "0.9 mi"},
        {"name": "Mill Creek Park", "rating": 4.6, "distance": "2.2 mi"},
    ],
    "Entertainment": [
        {"name": "AMC Classic Theater", "rating": 4.3, "distance": "1.7 mi"},
        {"name": "The Painted Shark", "rating": 4.8, "distance": "0.8 mi"},
    ],
}

FAVORITES = {
    "user1": ["Vandy's BBQ", "RAC Sports Complex"]
}

@app.get("/categories")
def get_categories():
    return jsonify({
        "categories": list(PLACES.keys())
    })

@app.get("/top-rated")
def get_top_rated():
    category = request.args.get("category", "Food")
    results = sorted(PLACES.get(category, []), key=lambda x: -x["rating"])
    return jsonify(results)

@app.get("/spin")
def spin_wheel():
    category = request.args.get("category", "Food")
    choices = PLACES.get(category, [])
    if not choices:
        return jsonify({"error": "No places found for this category"}), 404

    return jsonify(random.choice(choices))

@app.get("/favorites/<user_id>")
def get_favorites(user_id):
    favs = FAVORITES.get(user_id, [])
    return jsonify({"favorites": favs})

app.run(host="0.0.0.0", port=5000)
