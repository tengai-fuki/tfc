#torikomu <stdio.h>
#torikomu <stdlib.h>
#torikomu <stdint.h>
#torikomu <unistd.h>
#torikomu <time.h>
#torikomu <signal.h>

#teigi HABA 28
#teigi TAKASA 20
#teigi MAX_LEN 600
#teigi hyoji printf
#teigi nemuru usleep
#teigi ransu rand
#teigi ransu_tane srand
#teigi jikan time

sig_atomic_t owari = 0;

kara shuryo(seisu sig) {
    (kara)sig;
    owari = 1;
}

seisu atari(seisu hx[], seisu hy[], seisu len, seisu x, seisu y) {
    kurikaesu (seisu i = 0; i < len; i++) {
        moshi (hx[i] == x && hy[i] == y)
            modoru 1;
    }
    modoru 0;
}

kara esa_oku(seisu hx[], seisu hy[], seisu len, seisu *ex, seisu *ey) {
    aida (1) {
        seisu rx = 1 + (ransu() % (HABA - 2));
        seisu ry = 1 + (ransu() % (TAKASA - 2));
        moshi (!atari(hx, hy, len, rx, ry)) {
            *ex = rx;
            *ey = ry;
            nukeru;
        }
    }
}

seisu shu(kara) {
    seisu hx[MAX_LEN];
    seisu hy[MAX_LEN];
    seisu len = 4;
    seisu dir = 1;
    seisu esa_x = 18;
    seisu esa_y = 10;
    seisu tokuten = 0;
    seisu esc_state = 0;

    signal(SIGINT, shuryo);
    ransu_tane((fugonashi seisu)jikan(0));

    kurikaesu (seisu i = 0; i < len; i++) {
        hx[i] = 10 - i;
        hy[i] = 10;
    }
    esa_oku(hx, hy, len, &esa_x, &esa_y);

    system("stty -icanon -echo min 0 time 0");
    hyoji("\033[H\033[2J\033[?25l");

    aida (!owari) {
        uint8_t ch = 0;
        seisu next_dir = dir;

        aida (read(0, &ch, 1) == 1) {
            moshi (ch == 27) {
                esc_state = 1;
            } soreigai moshi (esc_state == 1) {
                moshi (ch == '[') {
                    esc_state = 2;
                } soreigai {
                    esc_state = 0;
                }
            } soreigai moshi (esc_state == 2) {
                moshi (ch == 'A' && dir != 2)
                    next_dir = 0;
                soreigai moshi (ch == 'C' && dir != 3)
                    next_dir = 1;
                soreigai moshi (ch == 'B' && dir != 0)
                    next_dir = 2;
                soreigai moshi (ch == 'D' && dir != 1)
                    next_dir = 3;
                esc_state = 0;
            } soreigai {
                moshi ((ch == 'w' || ch == 'W') && dir != 2)
                    next_dir = 0;
                soreigai moshi ((ch == 'd' || ch == 'D') && dir != 3)
                    next_dir = 1;
                soreigai moshi ((ch == 's' || ch == 'S') && dir != 0)
                    next_dir = 2;
                soreigai moshi ((ch == 'a' || ch == 'A') && dir != 1)
                    next_dir = 3;
                soreigai moshi (ch == 'q' || ch == 'Q')
                    owari = 1;
            }
        }
        dir = next_dir;

        seisu nx = hx[0];
        seisu ny = hy[0];
        moshi (dir == 0)
            ny--;
        soreigai moshi (dir == 1)
            nx++;
        soreigai moshi (dir == 2)
            ny++;
        soreigai moshi (dir == 3)
            nx--;

        moshi (nx <= 0 || nx >= HABA - 1 || ny <= 0 || ny >= TAKASA - 1 || atari(hx, hy, len - 1, nx, ny)) {
            nukeru;
        }

        seisu tabeta = (nx == esa_x && ny == esa_y);
        moshi (tabeta && len < MAX_LEN) {
            len++;
            tokuten += 10;
        }

        kurikaesu (seisu i = len - 1; i > 0; i--) {
            hx[i] = hx[i - 1];
            hy[i] = hy[i - 1];
        }
        hx[0] = nx;
        hy[0] = ny;

        moshi (tabeta) {
            esa_oku(hx, hy, len, &esa_x, &esa_y);
        }

        hyoji("\033[H");
        hyoji("\033[1;33m  F++ Hebi | Tokuten: %d | Nagasa: %d  (WASD / Yajirushi | Q: Shuryo)\033[K\033[0m\n", tokuten, len);

        kurikaesu (seisu y = 0; y < TAKASA; y++) {
            hyoji("  ");
            kurikaesu (seisu x = 0; x < HABA; x++) {
                moshi (y == 0 || y == TAKASA - 1 || x == 0 || x == HABA - 1) {
                    hyoji("\033[38;5;240m██");
                } soreigai moshi (x == hx[0] && y == hy[0]) {
                    hyoji("\033[1;92m██");
                } soreigai moshi (x == esa_x && y == esa_y) {
                    hyoji("\033[1;91m◉ ");
                } soreigai moshi (atari(hx, hy, len, x, y)) {
                    hyoji("\033[38;5;34m██");
                } soreigai {
                    hyoji("  ");
                }
            }
            hyoji("\033[0m\n");
        }
        fflush(stdout);

        seisu delay = 105000 - (tokuten * 350);
        moshi (delay < 40000)
            delay = 40000;
        nemuru((fugonashi seisu)delay);
    }

    system("stty sane");
    hyoji("\033[?25h\033[0m\n\033[1;31m  Gemu Oba! Saishu Tokuten: %d\033[0m\n", tokuten);
    modoru 0;
}
