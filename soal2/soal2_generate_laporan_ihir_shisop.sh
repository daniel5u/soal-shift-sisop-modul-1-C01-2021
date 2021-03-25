#2a
awk '
function cost_price(s, p) {
    return (s - p)
}
function profit_ratio(p, cp) {
    return (p / cp)
}
function profit_percentage(pr) {
    return (pr * 100)
}
BEGIN {
    #2a
    max_pr = 0;
    max_row_id = 0;

    #2c
    flag_ts = 0;
    min_ts = 0;

    #2d
    flag_p = 0;
    min_p = 0;
}
{
    gsub(" ", "");
    if(NR > 1) {
        #2a
        curr_cost_price = cost_price($18, $21);
        if(curr_cost_price != 0) {
            if(NR == 2) {
                max_pr = profit_ratio($21, curr_cost_price);
                max_row_id = $1;
            }
            else {
                curr_pr = profit_ratio($21, curr_cost_price);
                if(max_pr < curr_pr) {
                    max_pr = curr_pr;
                    max_row_id = $1;
                }
                else if(max_pr == curr_pr) {
                    max_row_id = $1;
                }
            }
        }

        #2b
        split($3, date, "-");
        if(date[3] == 17 && $10 == "Albuquerque") {
            gsub("[A-Z]", " &", $7);
            name = substr($7, 2);
            customers[name]++;
        }

        #2c
        transactions[$8]++;

        #2d
        profits[$13] += $21;
    }
}
END {
    #2a
    printf("Transaksi terakhir dengan profit percentage terbesar yaitu %d dengan persentase %d%%.\n", 
    max_row_id, profit_percentage(max_pr));

    printf("\n");

    #2b
    print "Daftar nama customer di Albuquerque pada tahun 2017 antara lain:";
    for(customer in customers) {
        print customer;
    }

    printf("\n");

    #2c
    for(i in transactions) {
        if(flag_ts == 0) {
            min_ts = transactions[i];
            segment = i;
            flag_ts = 1;
        }
        if(min_ts > transactions[i]) {
            min_ts = transactions[i];
            segment = i;
        }
    }
    gsub("[A-Z]", " &", segment);
    segment = substr(segment, 2);
    printf("Tipe segmen customer yang penjualannya paling sedikit adalah %s dengan %d transaksi.\n", segment, min_ts);

    printf("\n");

    #2d
    for(i in profits) {
        if(flag_p == 0) {
            min_p = profits[i];
            region = i;
            flag_p = 1;
        }
        if(min_p > profits[i]) {
            min_p = profits[i];
            region = i;
        }
    }
    printf("Wilayah bagian (region) yang memiliki total keuntungan (profit) yang paling sedikit adalah %s dengan total keuntungan %f\n",
    region, min_p);
}' Laporan-TokoShiSop.tsv