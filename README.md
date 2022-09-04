# ASCII ART Convertor

This project is a web server to host a full stack website that converts Images 
given by a user to ASCII ART images.


The project uses a Flask back-end server, and Svelte for the front.

## Installation

Note: If you have the make utility, you can use the following:
```bash
make
```

Setup the back-end:
```coffeescript
pip install -r requirements.txt
flask run
```

Setup the front-end:
```coffeescript
cd client
npm install
npm run autobuild
```