#torikomu <stdio.h>
#torikomu <stdlib.h>
#torikomu <unistd.h>
#torikomu <time.h>
#torikomu <signal.h>

#teigi HABA 48
#teigi TAKASA 26
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

kara shokika(seisu genzai[TAKASA][HABA]) {
    kurikaesu (seisu y = 0; y < TAKASA; y++) {
        kurikaesu (seisu x = 0; x < HABA; x++) {
            moshi ((ransu() % 100) < 28) {
                genzai[y][x] = 1;
            } soreigai {
                genzai[y][x] = 0;
            }
        }
    }
}

seisu kazoeru(seisu genzai[TAKASA][HABA], seisu y, seisu x) {
    seisu tonari = 0;
    kurikaesu (seisu dy = -1; dy <= 1; dy++) {
        kurikaesu (seisu dx = -1; dx <= 1; dx++) {
            moshi (dy != 0 || dx != 0) {
                seisu ny = (y + dy + TAKASA) % TAKASA;
                seisu nx = (x + dx + HABA) % HABA;
                moshi (genzai[ny][nx] > 0)
                    tonari++;
            }
        }
    }
    modoru tonari;
}

seisu shu(kara) {
    seisu genzai[TAKASA][HABA];
    seisu tsugi[TAKASA][HABA];
    seisu sedai = 0;

    signal(SIGINT, shuryo);
    ransu_tane((fugonashi seisu)jikan(0));
    shokika(genzai);

    hyoji("\033[H\033[2J\033[?25l");

    aida (1) {
        seisu seizon = 0;
        seisu henka = 0;

        hyoji("\033[H");
        hyoji("\033[1;36m  F++ Inochi no Gemu | Sedai: %d (Ctrl+C: Shuryo)\033[K\033[0m\n\n", sedai);

        kurikaesu (seisu y = 0; y < TAKASA; y++) {
            hyoji("  ");
            kurikaesu (seisu x = 0; x < HABA; x++) {
                seisu c = genzai[y][x];
                moshi (c == 1) {
                    hyoji("\033[1;92m██");
                    seizon++;
                } soreigai moshi (c > 1) {
                    hyoji("\033[38;5;34m██");
                    seizon++;
                } soreigai {
                    hyoji("\033[38;5;235m··");
                }
            }
            hyoji("\033[0m\n");
        }

        hyoji("\n\033[1;37m  Seizon saibo: %d\033[K\033[0m\n", seizon);
        fflush(stdout);

        kurikaesu (seisu y = 0; y < TAKASA; y++) {
            kurikaesu (seisu x = 0; x < HABA; x++) {
                seisu n = kazoeru(genzai, y, x);
                seisu c = genzai[y][x];
                moshi (c > 0) {
                    moshi (n == 2 || n == 3) {
                        tsugi[y][x] = c + 1;
                    } soreigai {
                        tsugi[y][x] = 0;
                        henka = 1;
                    }
                } soreigai {
                    moshi (n == 3) {
                        tsugi[y][x] = 1;
                        henka = 1;
                    } soreigai {
                        tsugi[y][x] = 0;
                    }
                }
            }
        }

        kurikaesu (seisu y = 0; y < TAKASA; y++) {
            kurikaesu (seisu x = 0; x < HABA; x++) {
                genzai[y][x] = tsugi[y][x];
            }
        }

        sedai++;
        moshi (!henka || seizon == 0) {
            nemuru(800000);
            shokika(genzai);
            sedai = 0;
        }

        nemuru(75000);
    }

    modoru 0;
}
