#!/bin/sh

myArray=(7)
OPArray=("fadd_s_D" "neg_v_8B" "sqsub_s_B" "uminp_v_8B" "orr_v_imm_4H" "bic_v_reg_16B" "fcmge_s_D" "facgt_v_2S" "fcvt_HtoS" "fcvtnu_v_4S" "fmadd_s_D" "fmul_v_2D" "mul_v_8B" "sqdmlsl_s_S" "umull_v_2D" "fdiv_v_2D" "fdiv_s_2D" "fdiv_v_2S" "frecpe_v_2D" "frsqrte_s_S" "frsqrte_v_2D")
REPEAT=5

DIR=`date +"%Y%m%d_%H%M%S"`

test_insn () {
  if [ $1 == "fadd_s_D" ]
  then
    echo "        fadd d0, d0, d1" >> $DIR/$1_$2.s
  elif [ $1 == "fsub_v_4H" ]
  then
    echo "        fsub v0.4h, v0.4h, v1.4h" >> $DIR/$1_$2.s
  elif [ $1 == "neg_v_8B" ]
  then
    echo "        neg v0.8b, v0.8b" >> $DIR/$1_$2.s
  elif [ $1 == "sqsub_s_B" ]
  then
    echo "        sqsub b0, b0, b1" >> $DIR/$1_$2.s
  elif [ $1 == "uminp_v_8B" ]
  then
    echo "        uminp v0.8b, v0.8b, v1.8b" >> $DIR/$1_$2.s
  elif [ $1 == "orr_v_imm_4H" ]
  then
    echo "        orr v0.4h, #1" >> $DIR/$1_$2.s
  elif [ $1 == "bic_v_reg_16B" ]
  then
    echo "        bic v0.16b, v0.16b, v1.16b" >> $DIR/$1_$2.s
  elif [ $1 == "fcmeq_v_4H" ]
  then
    echo "        fcmeq v0.4h, v0.4h, v1.4h" >> $DIR/$1_$2.s
  elif [ $1 == "fcmge_s_D" ]
  then
    echo "        fcmge d0, d0, d1" >> $DIR/$1_$2.s
  elif [ $1 == "facgt_v_2S" ]
  then
    echo "        facgt v0.2s, v0.2s, v1.2s" >> $DIR/$1_$2.s
  elif [ $1 == "fcvt_HtoS" ]
  then
    echo "        fcvt s0, h0" >> $DIR/$1_$2.s
  elif [ $1 == "fcvtnu_v_4S" ]
  then
    echo "        fcvtnu v0.4s, v0.4s" >> $DIR/$1_$2.s
  elif [ $1 == "fcvtzs_s_int_4H" ]
  then
    echo "        fcvtzs h0, h0" >> $DIR/$1_$2.s
  elif [ $1 == "fmadd_s_D" ]
  then
    echo "        fmadd d0, d0, d1, d2" >> $DIR/$1_$2.s
  elif [ $1 == "fmul_v_2D" ]
  then
    echo "        fmul v0.2d, v0.2d, v1.2d" >> $DIR/$1_$2.s
  elif [ $1 == "mul_v_8B" ]
  then
    echo "        mul v0.8b, v0.8b, v1.8b" >> $DIR/$1_$2.s
  elif [ $1 == "sqdmlsl_s_S" ]
  then
    echo "        sqdmlsl s0, h1, h2" >> $DIR/$1_$2.s
  elif [ $1 == "umull_v_2D" ]
  then
    echo "        umull v0.2d, v0.2s, v1.2s" >> $DIR/$1_$2.s
  elif [ $1 == "fdiv_v_2D" ]
  then
    echo "        fdiv v0.2d, v0.2d, v1.2d" >> $DIR/$1_$2.s
  elif [ $1 == "fdiv_s_2D" ]
  then
    echo "        fdiv d0, d0, d1" >> $DIR/$1_$2.s
  elif [ $1 == "fdiv_v_8H" ]
  then
    echo "        fdiv v0.8h, v0.8h, v1.8h" >> $DIR/$1_$2.s
  elif [ $1 == "fdiv_v_2S" ]
  then
    echo "        fdiv v0.2s, v0.2s, v1.2s" >> $DIR/$1_$2.s
  elif [ $1 == "fdiv_s_H" ]
  then
    echo "        fdiv h0, h0, h1" >> $DIR/$1_$2.s
  elif [ $1 == "frecpe_s_H" ]
  then
    echo "        frecpe h0, h0" >> $DIR/$1_$2.s
  elif [ $1 == "frecpe_v_2D" ]
  then
    echo "        frecpe v0.2d, v0.2d" >> $DIR/$1_$2.s
  elif [ $1 == "frsqrte_s_S" ]
  then
    echo "        frsqrte s0, s0" >> $DIR/$1_$2.s
  elif [ $1 == "frsqrte_v_2D" ]
  then
    echo "        frsqrte v0.2d, v0.2d" >> $DIR/$1_$2.s
  else
    continue
  fi
}

initialise () {
  echo "        movi v0.16b, 1" >> $DIR/$1_$2.s
  echo "        movi v1.16b, 2" >> $DIR/$1_$2.s
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
  echo "        bne _start+0x10" >> $DIR/$1_$2.s
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

cat $0 > $DIR/build.txt
echo "= = = = = The file name is $0 = = = = =" >> $DIR/build.txt

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

