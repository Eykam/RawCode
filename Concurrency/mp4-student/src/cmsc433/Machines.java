package cmsc433;

import java.util.concurrent.*;
import java.util.ArrayList;
/**
 * Machines are used to make different kinds of Food. Each Machine type makes
 * just one kind of Food. Each machine type has a count: the set of machines of
 * that type can make that many food items in parallel. If the machines are
 * asked to produce a food item beyond its count, the requester blocks. Each
 * food item takes at least item.cookTime10S seconds to produce. In this
 * simulation, use Thread.sleep(item.cookTime10S) to simulate the actual cooking
 * time.
 */
public class Machines {

	public enum MachineType {
		sodaMachines, fryers, grillPresses, ovens
	};

	// Converts Machines instances into strings based on MachineType.
	public String toString() {
		switch (machineType) {
			case sodaMachines:
				return "Soda Machines";
			case fryers:
				return "Fryers";
			case grillPresses:
				return "Grill Presses";
			case ovens:
				return "Ovens";
			default:
				return "INVALID MACHINE TYPE";
		}
	}

	public final MachineType machineType;
	public final Food machineFoodType;
	// YOUR CODE GOES HERE...
	public Semaphore machineLock;
	public int count;
	public Thread[] foodThreads;
	public ArrayList<FoodOrder> foodList;


	/**
	 * The constructor takes at least the name of the machines, the Food item they
	 * make, and their count. You may extend it with other arguments, if you wish.
	 * Notice that the constructor currently does nothing with the count; you must
	 * add code to make use of this field (and do whatever initialization etc. you
	 * need).
	 */
	public Machines(MachineType machineType, Food foodIn, int countIn) {
		this.machineType = machineType;
		this.machineFoodType = foodIn;
		this.count = countIn;
		this.foodList = new ArrayList<FoodOrder>();
		// YOUR CODE GOES HERE...
		this.machineLock = new Semaphore(countIn);
		foodThreads = new Thread[count];
		for (int i=0; i < foodThreads.length; i++) {
			Runnable runnable = new CookAnItem();
			Thread currThread = new Thread(runnable);
			foodThreads[i] = currThread;
			foodThreads[i].start();
		}


	}

	/**
	 * This method is called by a Cook in order to make the Machines' food item. You
	 * can extend this method however you like, e.g., you can have it take extra
	 * parameters or return something other than Object. You will need to implement
	 * some means to notify the calling Cook when the food item is finished.
	 */
	public void makeFood(Cook cook, Food food, int orderNum) throws InterruptedException {
		foodList.add(new FoodOrder(cook,food,orderNum));	
	}

	// THIS MIGHT BE A USEFUL METHOD TO HAVE AND USE BUT IS JUST ONE IDEA
	private class CookAnItem implements Runnable {
		public void run() {
			try {
				while(true) {
					
					FoodOrder currFood = null;
					boolean acquired = false;
					synchronized(foodList) {
						if(foodList.size() != 0) {
							machineLock.acquire();
							currFood = foodList.get(0);
							acquired=true;
							foodList.remove(0);
							Simulation.logEvent(SimulationEvent.machinesCookingFood(Machines.this, currFood.food));
							Thread.sleep(currFood.food.cookTime10S);
							Simulation.logEvent(SimulationEvent.machinesDoneFood(Machines.this, machineFoodType));
							Simulation.logEvent(SimulationEvent.cookFinishedFood(currFood.cook,currFood.food,currFood.orderNum));
							currFood.cook.completeOrder.countDown();
								
						}
					}
						
						
					if(acquired)
						machineLock.release();
					
					Thread.sleep(10);
				}
			} catch(InterruptedException e) { }
		}
	}
	
	private class FoodOrder {
		Cook cook;
		Food food;
		int orderNum;
		
		private FoodOrder(Cook cook, Food food, int orderNum) {
			this.cook = cook;
			this.food = food;
			this.orderNum = orderNum;
		}
		
	}
}
