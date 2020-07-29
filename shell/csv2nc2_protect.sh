cp ../data/ncheader_all_protect.txt ../output/csv/ncheader_all_protect.txt

cat ../output/csv/ncheader_all_protect.txt ../output/csv/protect.csv ../output/csv/final.txt > ../output/cdl/protect.cdl
ncgen -o ../output/nc/protect.nc -x ../output/cdl/protect.cdl

