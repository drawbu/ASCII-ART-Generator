PM = npm
NPM_FLAGS = --prefix client

V_BIN = venv/bin
J_BIN = client/node_modules/.bin

ENV = .flaskenv
FRONT_BUILD = client/public/build

FLASK_CMD = $(V_BIN)/flask
BUILD_MODE = build


all: start


$(J_BIN)/rollup:
	$(PM) install $(NPM_FLAGS)


$(FRONT_BUILD): $(J_BIN)/rollup
	$(J_BIN) run $(NPM_FLAGS) $(BUILD_MODE)


$(V_BIN):
	python3 -m venv venv
	chmod +x $(V_BIN)/activate
	./$(V_BIN)/activate

$(ENV):
	echo 'DEBUG_MODE=false' > $(ENV)

$(FLASK_CMD): $(V_BIN) $(ENV)
	$(V_BIN)/pip install -e .


start: $(FLASK_CMD) client/public/build
	$(FLASK_CMD) --app server run


dev:
	make -j2 start BUILD_MODE='autobuild &'


clean:
	rm -rf */__pycache__
	rm -rf *egg-info


fclean: clean
	rm -f .flaskenv
	rm -rf client/node_modules
	rm -rf venv


.PHONY: all clean dev fclean start
