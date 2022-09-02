#!/bin/sh

myArray=(1 2 3 4 5 6 7 8)
OPArray=("and_reg_asr_64" "cmp_imm_64" "sdiv_fast_64" "mul_64")
REPEAT=10

DIR=`date +"%Y%m%d_%H%M%S"`

test_insn () {
  if [ $1 == "and_imm_64" ]
  then
    echo "        and x1, x2, #3" >> $DIR/$1_$2.s
  elif [ $1 == "and_reg_64" ]
  then
    echo "        and x1, x2, x2" >> $DIR/$1_$2.s
  elif [ $1 == "and_reg_asr_64" ]
  then
    echo "        and x1, x8, x2, asr #17" >> $DIR/$1_$2.s
  elif [ $1 == "ands_reg_64" ]
  then
    echo "        ands x1, x2, x2" >> $DIR/$1_$2.s
  elif [ $1 == "ands_reg_ror_64" ]
  then
    echo "        ands x1, x2, x2, ror #17" >> $DIR/$1_$2.s
  elif [ $1 == "cmp_uxtw_64" ]
  then
    echo "        cmp x1, w2, uxtw" >> $DIR/$1_$2.s
  elif [ $1 == "cmp_imm_64" ]
  then
    echo "        cmp x1, #3" >> $DIR/$1_$2.s
  elif [ $1 == "cmp_reg_64" ]
  then
    echo "        cmp x1, x2" >> $DIR/$1_$2.s
  elif [ $1 == "cmp_reg_asr_64" ]
  then
    echo "        cmp x1, x2, asr #17" >> $DIR/$1_$2.s
  elif [ $1 == "sdiv_fast_64" ]
  then
    echo "        sdiv x1, x2, x2" >> $DIR/$1_$2.s
  elif [ $1 == "mul_32" ]
  then
    echo "        mul w1, w2, w2" >> $DIR/$1_$2.s
  elif [ $1 == "mul_64" ]
  then
    echo "        mul x1, x2, x2" >> $DIR/$1_$2.s
  elif [ $1 == "umull" ]
  then
    echo "        umull x1, w2, w2" >> $DIR/$1_$2.s
  else
    continue
  fi
}

initialise () {
  echo "        mov x0, 1" >> $DIR/$1_$2.s
  echo "        mov x1, 2" >> $DIR/$1_$2.s
  echo "        mov x2, 1" >> $DIR/$1_$2.s
  echo "        mov x0, #1000" >> $DIR/$1_$2.s
  echo "        mul x0, x0, x0" >> $DIR/$1_$2.s

}

generate_head () {
  echo ".global _start" >> $DIR/$1_$2.s
  echo ".align 2" >> $DIR/$1_$2.s
  echo "_start:" >> $DIR/$1_$2.s
}

generate_tail () {
  echo "        add x3, x3, #1" >> $DIR/$1_$2.s
  echo "        cmp x3, x0" >> $DIR/$1_$2.s
  echo "        bne _start+0x14" >> $DIR/$1_$2.s
  echo "        add x5, x5, #48" >> $DIR/$1_$2.s
  echo "        ldr x6, =num" >> $DIR/$1_$2.s
  echo "        str x5, [x6]" >> $DIR/$1_$2.s
  echo "        mov x0, #1" >> $DIR/$1_$2.s
  echo "        ldr x1, =num" >> $DIR/$1_$2.s
  echo "        mov x2, #1" >> $DIR/$1_$2.s
  echo "        mov x8, #64" >> $DIR/$1_$2.s
  echo "        svc #0" >> $DIR/$1_$2.s
  echo "        mov x0, #0" >> $DIR/$1_$2.s
  echo "        mov x8, #94" >> $DIR/$1_$2.s
  echo "        svc #0" >> $DIR/$1_$2.s
  echo ".data" >> $DIR/$1_$2.s
  echo "num:" >> $DIR/$1_$2.s
  echo '        .ascii " "' >> $DIR/$1_$2.s
}

mkdir -p $DIR

for OP in "${OPArray[@]}"; do
  for i in ${myArray[@]}; do
    generate_head $OP $i
    initialise $OP $i
    if [ $i != "0" ]
    then
      for (( j=0; j<($i); j++ ));
      do
        test_insn $OP $i
      done
    fi
    generate_tail $OP $i
    as $DIR/${OP}_${i}.s -o $DIR/${OP}_${i}.o
    ld -static $DIR/${OP}_${i}.o -o $DIR/${OP}_${i}
  done
done

[ -e $DIR/results.txt ] && rm $DIR/results.txt

date > $DIR/results.txt

for ((i = 1; i <= $REPEAT; i++)); do
  for f in $DIR/*; do
    if [ -f "$f" ] && [ -x "$f" ]; then
      echo "File_name = $f" >> $DIR/results.txt
      sudo taskset -c 4 perf stat -C 4 --all-user -e cycles,instructions "$f" &>> $DIR/results.txt
    fi
  done
done

echo "End End End" &>> $DIR/results.txt

[ -e $DIR/sim_results.txt ] && rm $DIR/sim_results.txt

date > $DIR/sim_results.txt

for f in $DIR/*; do
  if [ -f "$f" ] && [ -x "$f" ]; then
    echo "File_name = $f" >> $DIR/sim_results.txt
    /home/liyun/project/install/bin/simeng /home/liyun/project/SimEng/configs/m1fs_v1p1.yaml $f >> $DIR/sim_results.txt
  fi
done

cat $0 > $DIR/build.txt

echo "= = = = = The file name is $0 = = = = =" >> $DIR/build.txt
