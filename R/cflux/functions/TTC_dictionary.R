##### Rename TTC plots
dict_TTC <- read.table(header = TRUE, stringsAsFactors = FALSE, text =
                         "new old
                       51TTC Fau1C
                       57TTC Fau2C
                       68TTC Fau4C
                       73TTC Fau5C
                       29TTC Alr1C
                       31TTC Alr2C
                       134TTC Vik2C
                       140TTC Vik3C
                       141TTC Vik4C
                       146TTC Vik5C
                       101TTC Hog1C
                       110TTC Hog2C
                       115TTC Hog3C
                       286TTC Ovs1C
                       291TTC Ovs2C
                       297TTC Ovs3C
                       211TTC Arh1C
                       222TTC Arh3C
                       226TTC Arh4C
                       263TTC Ves1C
                       281TTC Ves5C
                       281TTC Ves4C
                       194TTC Ram4C
                       198TTC Ram5C
                       6TTC Ulv2C
                       11TTC Ulv3C
                       236TTC Skj1C
                       243TTC Skj2C
                       246TTC Skj3C
                       251TTC Skj4C
                       511TTC Gud12C
                       46TTC Alr4TTC
                       307TTC Ovs5TTC
                       216TTC Arh2TTC
                       61TTC Fau3TTC
                       78TTC  Lav1TTC
                       85TTC  Lav2TTC
                       87TTC  Lav3TTC
                       94TTC  Lav4TTC
                       99TTC  Lav5TTC") %>%
  mutate(new = str_replace(new, "TTC", " TTC"))
