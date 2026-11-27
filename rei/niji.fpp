#torikomu <stdio.h>
#torikomu <stdlib.h>
#torikomu <unistd.h>
#torikomu <time.h>
#torikomu <signal.h>

#teigi KAZU 24
#teigi hyoji printf
#teigi nemuru usleep
#teigi ransu rand
#teigi ransu_tane srand
#teigi jikan time

kara shuryo(seisu sig) {
    (kara)sig;
    write(1, "\033[?25h\033[0m\n", 11);
    _exit(0);
}

kara gamen_kesu(kara) {
    hyoji("\033[H\033[2J\033[?25l");
}

kara bo_hyoji(seisu *hairetsu, seisu aka1, seisu aka2, seisu kanryo) {
    seisu iro[6] = {196, 208, 226, 46, 51, 201};
    hyoji("\033[H");
    hyoji("\033[1;37m  F++ v0.1.0 Tesuto | Niji Seiretsu (Ctrl+C: Shuryo)\033[0m\n\n");

    kurikaesu (seisu i = 0; i < KAZU; i++) {
        moshi (kanryo) {
            hyoji("\033[1;32m");
        } soreigai moshi (i == aka1 || i == aka2) {
            hyoji("\033[1;97m");
        } soreigai {
            seisu c = iro[(hairetsu[i] * 6) / (KAZU + 1)];
            hyoji("\033[38;5;%dm", c);
        }

        hyoji(" %2d | ", hairetsu[i]);
        kurikaesu (seisu j = 0; j < hairetsu[i] * 2; j++) {
            hyoji("█");
        }
        hyoji("\033[K\033[0m\n");
    }
    fflush(stdout);
}

kara mazeru(seisu *hairetsu) {
    kurikaesu (seisu i = 0; i < KAZU; i++) {
        hairetsu[i] = i + 1;
    }
    kurikaesu (seisu i = KAZU - 1; i > 0; i--) {
        seisu j = ransu() % (i + 1);
        seisu tmp = hairetsu[i];
        hairetsu[i] = hairetsu[j];
        hairetsu[j] = tmp;
    }
}

seisu shu(kara) {
    seisu hairetsu[KAZU];
    signal(SIGINT, shuryo);
    ransu_tane((fugonashi seisu)jikan(0));
    gamen_kesu();

    aida (1) {
        mazeru(hairetsu);
        bo_hyoji(hairetsu, -1, -1, 0);
        nemuru(600000);

        seisu irekae = 1;
        seisu hajime = 0;
        seisu migi = KAZU - 1;

        aida (irekae) {
            irekae = 0;
            kurikaesu (seisu i = hajime; i < migi; i++) {
                moshi (hairetsu[i] > hairetsu[i + 1]) {
                    seisu tmp = hairetsu[i];
                    hairetsu[i] = hairetsu[i + 1];
                    hairetsu[i + 1] = tmp;
                    irekae = 1;
                    bo_hyoji(hairetsu, i, i + 1, 0);
                    nemuru(18000);
                }
            }
            moshi (!irekae)
                nukeru;

            irekae = 0;
            migi--;
            kurikaesu (seisu i = migi - 1; i >= hajime; i--) {
                moshi (hairetsu[i] > hairetsu[i + 1]) {
                    seisu tmp = hairetsu[i];
                    hairetsu[i] = hairetsu[i + 1];
                    hairetsu[i + 1] = tmp;
                    irekae = 1;
                    bo_hyoji(hairetsu, i, i + 1, 0);
                    nemuru(18000);
                }
            }
            hajime++;
        }

        bo_hyoji(hairetsu, -1, -1, 1);
        nemuru(1200000);
    }

    modoru 0;
}
