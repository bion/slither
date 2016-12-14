class UnsafeQueue
  class Node
    attr_reader :val
    attr_accessor :prev_node, :next_node

    def initialize(val, next_node = nil, prev_node = nil)
      @val = val
      @prev_node = prev_node
      @next_node = next_node
    end
  end

  attr_reader :size

  def initialize
    @head = @tail = nil
    @size = 0
  end

  def push(val)
    @size += 1

    if @head
      new_node = Node.new(val, @head)
      @head.prev_node = new_node
      @head = new_node
    else
      @head = Node.new(val)
      @tail = @head
    end

    self
  end

  alias :enq :push
  alias :<<  :push

  def pop
    return nil unless @tail

    @size -= 1

    dequeued = @tail
    @tail = @tail.prev_node
    @tail.next_node = nil if @tail

    dequeued.val
  end

  alias :deq :pop
  alias :shift :pop

  def empty?
    @size == 0
  end

  def clear
    @tail = @head = nil
    @size = 0
  end

  alias :reset :clear
end
