PM = npm
NPM_FLAGS = --prefix client

V_BIN = venv/bin
FLASK_CMD = $(V_BIN)/flask


all: start


client/node_modules:
	$(PM) install $(NPM_FLAGS)


client/public/build: client/node_modules
	$(PM) run $(NPM_FLAGS) build


$(V_BIN):
	python3 -m venv venv
	chmod +x $(V_BIN)/activate
	./$(V_BIN)/activate


$(FLASK_CMD): $(V_BIN)
	$(V_BIN)/pip install -r requirements.txt


start: $(FLASK_CMD) client/public/build
	$(FLASK_CMD) run


clean:
	rm -rf */__pycache__


fclean:
	rm -rf client/node_modules
	rm -rf venv


.PHONY: all clean fclean start
