
def read_perf_file(input_file, output_file):
  count = 1
  new_line = []

  check_point = list(input_file.readline().split())[2]

  while check_point != "End":
    new_line.append(str(count))
    # file_name = list(input_file.readline().split())[2]
    file_name = check_point
    print (file_name)
    new_line.append(file_name)

    input_file.readline()     # space 
    # Performance counter stats for 'CPU(s) 4':
    check = list(input_file.readline().split())[0]
    if 'Performance' not in check:
      input_file.readline()
    input_file.readline()     # space
    #print (input_file.readline())     # cycles
    cycles = list(input_file.readline().replace(",","").split())[0]
    print (cycles)
    new_line.append(cycles)

    #print (input_file.readline())     # instructions 
    insn_list = list(input_file.readline().replace(",","").split())
    insns = insn_list[0]
    print (insns)
    new_line.append(insns)
    insns_per_cycle = insn_list[3]
    print (insns_per_cycle)
    new_line.append(insns_per_cycle)

    input_file.readline()     # space
    time = list(input_file.readline().split())[0]     # time
    print (time)
    new_line.append(time)

    input_file.readline()     # space
    #print (input_file.readline())      # End

    line = ",".join(new_line)
    print (line)
    output_file.write(line + "\n")

    new_line.clear()
  
    count += 1
    check_point = list(input_file.readline().split())[2]
