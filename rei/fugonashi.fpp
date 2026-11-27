#torikomu <stdio.h>
#torikomu <stdlib.h>
#torikomu <stdint.h>

#teigi hyoji printf
#teigi yomu scanf
#teigi BASE ((uint64_t)1000000000 * (uint64_t)1000000000)
#teigi MAX_N 200000

seisu shu(kara) {
    int64_t n = 0;

    hyoji("Kazu wo nyuryoku (0 - %d): ", MAX_N);
    fflush(stdout);

    moshi (yomu("%ld", &n) != 1 || n < 0) {
        hyoji("Era: 0 matawa sei no seisu wo nyuryoku shite kudasai.\n");
        modoru 1;
    }

    moshi (n > MAX_N) {
        hyoji("PC hogo: Ichido ni saidai %d made nyuryoku dekimasu.\n", MAX_N);
        modoru 1;
    }

    moshi (n == 0) {
        hyoji("fibonacchi(0) [1 keta] =\n0\n");
        modoru 0;
    }

    moshi (n == 1) {
        hyoji("fibonacchi(1) [1 keta] =\n1\n");
        modoru 0;
    }

    int64_t max_limbs = (n / 80) + 4;
    uint64_t *a = (uint64_t *)calloc((size_t)max_limbs, 8);
    uint64_t *b = (uint64_t *)calloc((size_t)max_limbs, 8);
    uint64_t *c = (uint64_t *)calloc((size_t)max_limbs, 8);

    moshi (!a || !b || !c) {
        free(a);
        free(b);
        free(c);
        hyoji("Era: Memori wo kakuho dekimasendeshita.\n");
        modoru 1;
    }

    a[0] = 0;
    b[0] = 1;
    int64_t len = 1;

    kurikaesu (int64_t step = 2; step <= n; step++) {
        uint64_t carry = 0;
        kurikaesu (int64_t i = 0; i < len; i++) {
            uint64_t sum = a[i] + b[i] + carry;
            moshi (sum >= BASE) {
                c[i] = sum - BASE;
                carry = 1;
            } soreigai {
                c[i] = sum;
                carry = 0;
            }
        }
        moshi (carry > 0) {
            c[len] = carry;
            len++;
        }

        uint64_t *tmp = a;
        a = b;
        b = c;
        c = tmp;
    }

    int64_t top_digits = 0;
    uint64_t top = b[len - 1];
    aida (top > 0) {
        top /= 10;
        top_digits++;
    }
    int64_t total_digits = (len - 1) * 18 + top_digits;

    hyoji("Fibonacci(%ld) [%ld keta] =\n", n, total_digits);
    hyoji("%lu", b[len - 1]);
    kurikaesu (int64_t i = len - 2; i >= 0; i--) {
        hyoji("%018lu", b[i]);
    }
    hyoji("\n");

    free(a);
    free(b);
    free(c);
    modoru 0;
}
