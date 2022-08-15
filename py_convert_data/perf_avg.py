class Calculator:

  #num_list = []
  #average = 0
  #maximun = 0
  #minimun = 0
  #three_sigma = 0
  
  def __init__(self):
    print ("calculator ")
    self.num_list = []
    # self.avg = 0
    # self.max = 0
    # self.min = 100
    # self.three_sigma = 0

  def add_to_list(self, num):
    self.num_list.append(num)
    print (self.num_list)

  def calculate(self):
    count = 1
    sum = 0
    self.max = self.num_list[0]
    self.min = self.num_list[0]
    for n in self.num_list:
      self.max = max(self.max, n)
      self.min = min(self.min, n)
      sum += n
      count += 1

    self.avg = sum // count
    return [self.avg, self.max, self.min]

    
class insn:

  def __init__(self, name):
    self.name = name
    self.cycles = Calculator()
    self.insns = Calculator()
    # self.ipc = 0
    self.sec = Calculator()

  def add(self, i, num):
    if i == 1:
      self.cycles.add_to_list(num)
    elif i == 2:
      self.insns.add_to_list(num)
    elif i == 3:
      self.sec.add_to_list(num.replace('\n',''))

  def generate_row(self):
    result = []
    result += self.cycles.calculate()
    result += self.insns.calculate()
    # result += self.calculate()
    result += self.sec.calculate()


def read_perf_csv_file(input_file, output_file):
  mp = {}
  cols = list(input_file.readline().split(","))
  while cols[0]!="":
    name = cols[1]
    print (name)
    if name not in mp.keys():
      new_insn = insn(name)
      mp[name] = new_insn
      # print (new_insn)
      
    insn_cal = mp.get(name)
    insn_cal.add(1, cols[2])
    insn_cal.add(2, cols[3])
    insn_cal.add(3, cols[5])

    cols = list(input_file.readline().split(","))

  create_avg_file(mp, output_file)

def create_avg_file(mp, output_file):
  for item in mp.items():
    row = []
    row.append(str(item.key()))
    row += row + item.value().generate_row()

    line = ",".join(row)
    print (line)
    output_file.write(line + "\n")



def create_perf_avg_headline(output_file):
  output_file.write("#,file_name,averge,maximum,minimun,3sigma" + "\n")


def main():
  directory = input("input folder name: ")
  full_directory = "/home/og21893/proj_data/" + directory + "/"

  # calculate average and generate CSV file
  csv_name = full_directory + "perf_" + directory + ".CSV"
  input_file = open(csv_name, "r")

  avg_name = full_directory + "perf_avg_" + directory + ".CSV"
  output_file = open(avg_name, "w")
  create_perf_avg_headline(output_file)
  read_perf_csv_file(input_file, output_file)

  input_file.close()
  output_file.close()

main()