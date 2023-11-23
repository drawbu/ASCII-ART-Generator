FROM nixos/nix

# Setup repo
WORKDIR /poll
COPY . .

# Enable nix and flakes
RUN mkdir -p ~/.config/nix
RUN echo "experimental-features = nix-command flakes" | tee ~/.config/nix/nix.conf

# Build server
RUN nix build
RUN mkdir -p ascii

CMD ./result/bin/ascii-server /pool/ascii/ascii.sock
