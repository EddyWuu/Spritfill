# server for Spritfill

from flask import Flask

# initialize the Flask app
app = Flask(__name__)
# run the app
if __name__ == "__main__":
    app.run(debug=True)