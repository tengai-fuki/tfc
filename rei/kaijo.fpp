#torikomu <stdio.h>
#torikomu <stdlib.h>
#torikomu <stdint.h>

#teigi hyoji printf
#teigi yomu scanf
#teigi BASE 1000000000ULL
#teigi MAX_N 20000

seisu shu(kara) {
    int64_t n = 0;

    hyoji("Kaijo (n!) no kazu wo nyuryoku (0 - %d): ", MAX_N);
    fflush(stdout);

    moshi (yomu("%ld", &n) != 1 || n < 0) {
        hyoji("Era: 0 matawa sei no seisu wo nyuryoku shite kudasai.\n");
        modoru 1;
    }

    moshi (n > MAX_N) {
        hyoji("PC hogo: Ichido ni saidai %d made nyuryoku dekimasu.\n", MAX_N);
        modoru 1;
    }

    int64_t max_limbs = (n / 2) + 8;
    uint64_t *a = (uint64_t *)calloc((size_t)max_limbs, 8);
    moshi (!a) {
        hyoji("Era: Memori wo kakuho dekimasendeshita.\n");
        modoru 1;
    }

    a[0] = 1;
    int64_t len = 1;

    kurikaesu (int64_t step = 2; step <= n; step++) {
        uint64_t carry = 0;
        kurikaesu (int64_t i = 0; i < len; i++) {
            uint64_t prod = a[i] * (uint64_t)step + carry;
            a[i] = prod % BASE;
            carry = prod / BASE;
        }
        aida (carry > 0) {
            a[len] = carry % BASE;
            carry /= BASE;
            len++;
        }
    }

    int64_t top_digits = 0;
    uint64_t top = a[len - 1];
    aida (top > 0) {
        top /= 10;
        top_digits++;
    }
    int64_t total_digits = (len - 1) * 9 + top_digits;

    int64_t zeros = 0;
    int64_t t = n;
    aida (t >= 5) {
        t /= 5;
        zeros += t;
    }

    hyoji("%ld! [%ld keta | matsu no zero: %ld] =\n", n, total_digits, zeros);
    hyoji("%lu", a[len - 1]);
    kurikaesu (int64_t i = len - 2; i >= 0; i--) {
        hyoji("%09lu", a[i]);
    }
    hyoji("\n");

    free(a);
    modoru 0;
}
