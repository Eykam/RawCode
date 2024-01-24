package cmsc433;

import java.util.List;
import java.util.concurrent.*;

/**
 * Customers are simulation actors that have two fields: a name, and a list
 * of Food items that constitute the Customer's order. When running, an
 * customer attempts to enter the Ratsie's (only successful if the
 * Ratsie's has a free table), place its order, and then leave the
 * Ratsie's when the order is complete.
 */
public class Customer implements Runnable {
	// JUST ONE SET OF IDEAS ON HOW TO SET THINGS UP...
	private final String name;
	private final List<Food> order;
	private final int orderNum;
	private Semaphore sem;
	private static int runningCounter = 0;
	private CountDownLatch receivedLatch;

	/**
	 * You can feel free modify this constructor. It must take at
	 * least the name and order but may take other parameters if you
	 * would find adding them useful.
	 */
	public Customer(String name, List<Food> order, Semaphore sem) {
		this.name = name;
		this.order = order;
		this.orderNum = ++runningCounter;
		this.sem = sem;
		receivedLatch = new CountDownLatch(1);
		
	}

	public String toString() {
		return name;
	}

	/**
	 * This method defines what an Customer does: The customer attempts to
	 * enter the Ratsie's (only successful when the Ratsie's has a
	 * free table), place its order, and then leave the Ratsie's
	 * when the order is complete.
	 * @return 
	 */
	public void run() {
		
		Simulation.logEvent(SimulationEvent.customerStarting(this));
		boolean acquired = false;
		try {
			sem.acquire();
			acquired = true;
			Simulation.logEvent(SimulationEvent.customerEnteredRatsies(this));
			
			
			Simulation.logEvent(SimulationEvent.customerPlacedOrder(this, this.order, this.orderNum));
			Simulation.sendOrder(this);
			
			receivedLatch.await();
			Simulation.logEvent(SimulationEvent.customerReceivedOrder(this, this.order, this.orderNum));
			// Order food list
			//Check if cook is available
			//If available pass them an order
			//Wait until cook passes back order complete signal
//			Simulation.logEvent(SimulationEvent.customerReceivedOrder(this, this.order, this.orderNum));
//			latch.countDown();
			
		} catch (InterruptedException e) {
			
			// TODO Auto-generated catch block
			e.printStackTrace();
			
		} finally {
			if (acquired) {
				sem.release();
				Simulation.logEvent(SimulationEvent.customerLeavingRatsies(this));
			}
		}
		
	}
	
	public int getOrderNum() {
		return this.orderNum;
	}
	
	public List<Food> getOrder(){
		return this.order;
	}
	
	public void setReceived() {
		receivedLatch.countDown();
	}
}
