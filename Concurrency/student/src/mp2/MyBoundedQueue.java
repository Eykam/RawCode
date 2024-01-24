package mp2;

import java.util.*;

public class MyBoundedQueue<T> {
	private Object instanceLock;
	private ArrayList<T> queue;
	private int capacity;
	
	public MyBoundedQueue(int size) {
		this.instanceLock = new Object();
		this.queue = new ArrayList<T>();
		this.capacity = size;
	}
	
	// TODO: Implement put()
	// In a thread-safe manner:
	//		If there is space in the queue, add value to queue in FIFO order
	//		Otherwise, block operation
	public void put(T val) throws Exception {
		
		synchronized(instanceLock) {
			while(queue.size() == capacity)
				instanceLock.wait();
			
			queue.add(0,val);
			instanceLock.notifyAll();
		}
		
		return;
	}
	
	// TODO: Implement take()
	// In a thread-safe manner:
	//		If there are items in the queue, remove and return 
	//			first value from queue in FIFO order
	//		Otherwise, block operation
	public T take() throws Exception {
		
		synchronized(instanceLock) {
			
			while (queue.isEmpty()) 
				instanceLock.wait();
			
			
			T curr = queue.remove(0);
			instanceLock.notifyAll();
			
			return curr;
		}
		
		
	}
}
