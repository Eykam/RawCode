package cmsc433;

import java.util.concurrent.*;
import java.util.List;
/**
 * Cooks are simulation actors that have at least one field, a name.
 * When running, a cook attempts to retrieve outstanding orders placed
 * by Customer and process them.
 */
public class Cook implements Runnable {
	private final String name;
	private CountDownLatch latch;
	public CountDownLatch completeOrder;

	/**
	 * You can feel free modify this constructor. It must
	 * take at least the name, but may take other parameters
	 * if you would find adding them useful.
	 *
	 * @param: the name of the cook
	 */
	public Cook(String name, CountDownLatch orderLatch) {
		this.name = name;
		latch = orderLatch;
	}

	public String toString() {
		return name;
	}

	/**
	 * This method executes as follows. The cook tries to retrieve
	 * orders placed by Customers. For each order, a List<Food>, the
	 * cook submits each Food item in the List to an appropriate
	 * Machine type, by calling makeFood(). Once all machines have
	 * produced the desired Food, the order is complete, and the Customer
	 * is notified. The cook can then go to process the next order.
	 * If during its execution the cook is interrupted (i.e., some
	 * other thread calls the interrupt() method on it, which could
	 * raise InterruptedException if the cook is blocking), then it
	 * terminates.
	 */
	public void run() {

		Simulation.logEvent(SimulationEvent.cookStarting(this));
		
		try {
			List<Customer> currCustomers = Simulation.orders;
			
			while (true) {
				
					Customer curr = null;
					
					//Retrieve order from list
					synchronized(Simulation.orders) {
						if(currCustomers.size() != 0) {
							curr = Simulation.orders.get(0);
							Simulation.logEvent(SimulationEvent.cookReceivedOrder(this, curr.getOrder(), curr.getOrderNum()));
							Simulation.orders.remove(0);
						}
					}
					
					if(curr != null) {
						List<Food> order = curr.getOrder();
						
						//Send food item in order to machine to cook
						completeOrder = new CountDownLatch(order.size());
						for(int i = 0; i < order.size(); i++) {
							Food currFood = order.get(i);
							Simulation.logEvent(SimulationEvent.cookStartedFood(this,currFood,curr.getOrderNum()));
							//Create Cyclic barrier here to make sure all food is finished before
							try {
								Machines currMachine = null;
								switch(currFood.toString()) {
									case ("pizza"):
										currMachine = Simulation.machines[3];
										break;
									case ("soda"):
										currMachine = Simulation.machines[0];
										break;
									case ("subs"):
										currMachine = Simulation.machines[2];
										break;
									case("fries"):
										currMachine = Simulation.machines[1];
										break;
								}
								currMachine.makeFood(this,currFood,curr.getOrderNum());
								
							} catch (InterruptedException e) {
								System.out.println("Simulation thread interrupted.");
							}
							
						}
						//Find way to make sure order is complete
						//After order is done return and cleanup
						completeOrder.await();
						latch.countDown();
						curr.setReceived();
						Simulation.logEvent(SimulationEvent.cookCompletedOrder(this, curr.getOrderNum()));
				}
				Thread.sleep(10);
			}
		} catch (InterruptedException e) {
			// This code assumes the provided code in the Simulation class
			// that interrupts each cook thread when all customers are done.
			// You might need to change this if you change how things are
			// done in the Simulation class.
			Simulation.logEvent(SimulationEvent.cookEnding(this));
		}
	}
}
