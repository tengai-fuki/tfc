#torikomu <stdio.h>
#torikomu <stdlib.h>
#torikomu <stdint.h>

#teigi hyoji printf
#teigi yomu scanf
#teigi MAX_KETA 10000

kara div_small(int64_t *a, int64_t d, int64_t limbs) {
    int64_t rem = 0;
    kurikaesu (int64_t i = 0; i < limbs; i++) {
        int64_t cur = rem * 10000 + a[i];
        a[i] = cur / d;
        rem = cur % d;
    }
}

seisu div_to(int64_t *src, int64_t *dst, int64_t d, int64_t limbs) {
    int64_t rem = 0;
    seisu nonzero = 0;
    kurikaesu (int64_t i = 0; i < limbs; i++) {
        int64_t cur = rem * 10000 + src[i];
        int64_t q = cur / d;
        dst[i] = q;
        rem = cur % d;
        moshi (q != 0)
            nonzero = 1;
    }
    modoru nonzero;
}

kara add_to(int64_t *pi, int64_t *q, int64_t limbs) {
    int64_t carry = 0;
    kurikaesu (int64_t i = limbs - 1; i >= 0; i--) {
        int64_t s = pi[i] + q[i] + carry;
        moshi (s >= 10000) {
            pi[i] = s - 10000;
            carry = 1;
        } soreigai {
            pi[i] = s;
            carry = 0;
        }
    }
}

kara sub_from(int64_t *pi, int64_t *q, int64_t limbs) {
    int64_t borrow = 0;
    kurikaesu (int64_t i = limbs - 1; i >= 0; i--) {
        int64_t s = pi[i] - q[i] - borrow;
        moshi (s < 0) {
            pi[i] = s + 10000;
            borrow = 1;
        } soreigai {
            pi[i] = s;
            borrow = 0;
        }
    }
}

kara atan_keisan(int64_t *pi, int64_t *term, int64_t *quot, int64_t mult, int64_t x, int64_t x2, seisu sign, int64_t limbs) {
    kurikaesu (int64_t i = 0; i < limbs; i++) {
        term[i] = 0;
    }
    term[0] = mult;
    div_small(term, x, limbs);

    int64_t k = 1;
    aida (1) {
        seisu ok = div_to(term, quot, k, limbs);
        moshi (!ok)
            nukeru;

        moshi (sign > 0) {
            add_to(pi, quot, limbs);
        } soreigai {
            sub_from(pi, quot, limbs);
        }

        sign = -sign;
        k += 2;
        div_small(term, x2, limbs);
    }
}

seisu shu(kara) {
    int64_t keta = 0;

    hyoji("Enshuritsu no keta wo nyuryoku (1 - %d): ", MAX_KETA);
    fflush(stdout);

    moshi (yomu("%ld", &keta) != 1 || keta < 1 || keta > MAX_KETA) {
        hyoji("Era: 1 kara %d made no seisu wo nyuryoku shite kudasai.\n", MAX_KETA);
        modoru 1;
    }

    int64_t limbs = (keta / 4) + 6;
    int64_t *pi = (int64_t *)calloc((size_t)limbs, 8);
    int64_t *term = (int64_t *)calloc((size_t)limbs, 8);
    int64_t *quot = (int64_t *)calloc((size_t)limbs, 8);

    moshi (!pi || !term || !quot) {
        free(pi);
        free(term);
        free(quot);
        hyoji("Era: Memori wo kakuho dekimasendeshita.\n");
        modoru 1;
    }

    atan_keisan(pi, term, quot, 16, 5, 25, 1, limbs);
    atan_keisan(pi, term, quot, 4, 239, 57121, -1, limbs);

    hyoji("Pi [%ld keta] =\n%ld.", keta, pi[0]);
    int64_t printed = 0;
    kurikaesu (int64_t i = 1; i < limbs && printed < keta; i++) {
        int64_t rem_d = keta - printed;
        moshi (rem_d >= 4) {
            hyoji("%04ld", pi[i]);
            printed += 4;
        } soreigai moshi (rem_d == 3) {
            hyoji("%03ld", pi[i] / 10);
            printed += 3;
        } soreigai moshi (rem_d == 2) {
            hyoji("%02ld", pi[i] / 100);
            printed += 2;
        } soreigai {
            hyoji("%ld", pi[i] / 1000);
            printed += 1;
        }
    }
    hyoji("\n");

    free(pi);
    free(term);
    free(quot);
    modoru 0;
}
