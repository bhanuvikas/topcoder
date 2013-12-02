class BinPacker
  def initialize items=[]
    @bins = []
    @items = items
  end

  def pack
    @items.sort!
    @items.reverse!
    @items.each do |item|
      @bins.each_with_index do |bin, i|
        if bin + item <= 300
          @bins[i] = bin + item
          item = nil
          break
        end
      end
      @bins << item if item 
    end
    @bins.size
  end
end

[
  [[ 150, 150, 150, 150, 150 ], 3],
  [[ 130, 140, 150, 160 ], 2],
  [[ 101, 101, 101, 101, 101, 101, 101, 101, 101 ], 5],
  [[ 101, 200, 101, 101, 101, 101, 200, 101, 200 ], 6],
  [[ 123, 145, 167, 213, 245, 267, 289, 132, 154, 176, 198 ], 8]
].each do |tester|
  bp = BinPacker.new tester[0]
  packed = bp.pack
  if packed != tester[1]
    puts "Expected #{tester[1]} got #{packed}"
    puts tester[0].join ", "
  end
end
