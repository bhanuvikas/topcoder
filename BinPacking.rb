class BinPacker
  def initialize items=[]
    @bins = []
    @items = items
  end

  def min_bins
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
  [[ 100, 100, 100, 100, 100, 100, 100, 100, 100 ], 3],
  [[100, 200, 100, 100, 100, 100, 200, 100, 200], 4],
  [[157, 142, 167, 133, 135, 157, 143, 160, 141, 123, 162, 159, 165, 137, 138, 152], 8]
].each do |tester|
  bp = BinPacker.new tester[0]
  packed = bp.min_bins
  if packed != tester[1]
    puts "Expected #{tester[1]} got #{packed}"
    puts tester[0].join ", "
  end
end
