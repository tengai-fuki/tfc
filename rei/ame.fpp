#torikomu <stdio.h>
#torikomu <stdlib.h>
#torikomu <unistd.h>
#torikomu <time.h>
#torikomu <signal.h>

#teigi HABA 84
#teigi TAKASA 28
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

seisu shu(kara) {
    seisu y[HABA];
    seisu nagasa[HABA];
    seisu hayasa[HABA];
    seisu tick[HABA];
    seisu gamen[TAKASA][HABA];

    signal(SIGINT, shuryo);
    ransu_tane((fugonashi seisu)jikan(0));

    kurikaesu (seisu x = 0; x < HABA; x++) {
        y[x] = -(ransu() % TAKASA);
        nagasa[x] = 6 + (ransu() % 14);
        hayasa[x] = 1 + (ransu() % 3);
        tick[x] = 0;
        kurikaesu (seisu r = 0; r < TAKASA; r++) {
            gamen[r][x] = 33 + (ransu() % 94);
        }
    }

    hyoji("\033[H\033[2J\033[?25l");

    aida (1) {
        hyoji("\033[H");
        kurikaesu (seisu r = 0; r < TAKASA; r++) {
            kurikaesu (seisu x = 0; x < HABA; x++) {
                seisu dist = y[x] - r;
                moshi (dist == 0) {
                    gamen[r][x] = 33 + (ransu() % 94);
                    hyoji("\033[1;97m%c", gamen[r][x]);
                } soreigai moshi (dist > 0 && dist <= 3) {
                    moshi ((ransu() % 8) == 0)
                        gamen[r][x] = 33 + (ransu() % 94);
                    hyoji("\033[1;32m%c", gamen[r][x]);
                } soreigai moshi (dist > 3 && dist <= nagasa[x]) {
                    hyoji("\033[38;5;28m%c", gamen[r][x]);
                } soreigai moshi (dist > nagasa[x] && dist <= nagasa[x] + 4) {
                    hyoji("\033[38;5;22m%c", gamen[r][x]);
                } soreigai {
                    hyoji(" ");
                }
            }
            hyoji("\033[0m\n");
        }
        fflush(stdout);

        kurikaesu (seisu x = 0; x < HABA; x++) {
            tick[x]++;
            moshi (tick[x] >= hayasa[x]) {
                tick[x] = 0;
                y[x]++;
                moshi (y[x] - nagasa[x] - 5 > TAKASA) {
                    y[x] = -(ransu() % 12);
                    nagasa[x] = 6 + (ransu() % 14);
                    hayasa[x] = 1 + (ransu() % 3);
                }
            }
        }

        nemuru(35000);
    }

    modoru 0;
}
