from --platform=linux/arm64 lopsided/archlinux

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LANG_ALL en_US.UTF-8
ENV TERM xterm-256color
ENV HOME /root
ENV TMUX_PLUGIN_MANAGER_PATH "$HOME/.tmux/plugins/"
ENV PROXYCHAINS_QUIET_MODE 1
ENV DISPLAY host.docker.internal:0
RUN echo "LANG=en_US.UTF-8" > /etc/locale.conf
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
RUN locale-gen

RUN alias ua-drop-caches='sudo paccache -rk3; yay -Sc --aur --noconfirm'
RUN alias ua-update-all='export TMPFILE="$(mktemp)"; \
    sudo true; \
    rate-mirrors --save=$TMPFILE arch --max-delay=21600 \
      && sudo mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist-backup \
      && sudo mv $TMPFILE /etc/pacman.d/mirrorlist \
      && ua-drop-caches \
      && yay -Syyu --noconfirm'

RUN pacman-key --init && \
    pacman -Syu --noconfirm && \
    pacman -S curl --noconfirm 

RUN curl -o /etc/proxychains.conf https://raw.githubusercontent.com/x90skysn3k/dotfiles/main/proxychains.conf

RUN cd /tmp && curl -O https://raw.githubusercontent.com/x90skysn3k/dotfiles/main/install_arch.sh && chmod +x ./install_arch.sh && ./install_arch.sh && rm -rf /tmp/*

WORKDIR /root/

CMD [ "tmux" ]
