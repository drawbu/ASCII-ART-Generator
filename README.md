# ASCII ART Convertor

<img src="assets/screenshot.png" alt="Example of the project">

This project is a web server to host a full stack website that converts Images 
given by a user to ASCII ART images.

The project uses a Flask x Gunicorn back-end server, and Svelte for the front.

You can see a live example on [ascii.drawbu.dev](https://ascii.drawbu.dev).

## Installation

**Note:** If you have the make utility, you can use the following:
```bash
make
```

**Or**, you can do the setup manually: <br>
Set up the back-end:
```bash
pip install -r requirements.txt
gunicorn wsgi:app
```

Set up the front-end:
```bash
cd client
npm install
npm run autobuild
```