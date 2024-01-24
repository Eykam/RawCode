package cmsc433;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

/**
 * Validates a simulation
 */
public class Validate {
	private static int currentCustomers = 0;
	private static HashMap<String, List<SimulationEvent>> customerEvents = new HashMap<String, List<SimulationEvent>>(),
			cookEvents = new HashMap<String, List<SimulationEvent>>();
	private static HashMap<String, HashMap<String, Boolean>> customerChecks = new HashMap<String, HashMap<String, Boolean>>(),
			cookChecks = new HashMap<String, HashMap<String, Boolean>>();

	private static class InvalidSimulationException extends Exception {

		private static final long serialVersionUID = 1L;

		public InvalidSimulationException() {
		}
	};

	// Helper method for validating the simulation
	private static void check(boolean check, String message) throws InvalidSimulationException {
		if (!check) {
			System.err.println("SIMULATION INVALID : " + message);
			throw new Validate.InvalidSimulationException();
		}
	}

	private static void makeChecks() {

		// Customer
		Iterator<String> it = customerEvents.keySet().iterator();
		while (it.hasNext()) {
			String name = it.next();
			HashMap<String, Boolean> customerCheckList = new HashMap<String, Boolean>();

			// Customer Checks
			customerCheckList.put("Starting", false);
			customerCheckList.put("Entered", false);
			customerCheckList.put("Ordered", false);
			customerCheckList.put("Received Order", false);
			customerCheckList.put("Leaving", false);

			customerChecks.put(name, customerCheckList);
		}

		// Cook
		Iterator<String> it2 = cookEvents.keySet().iterator();
		while (it2.hasNext()) {
			String name = it2.next();
			HashMap<String, Boolean> cookCheckList = new HashMap<String, Boolean>();

			// Cook Checks
			cookCheckList.put("Starting", false);
			cookCheckList.put("Received Order", false);
			cookCheckList.put("Preparing Food", false);
			cookCheckList.put("Finished Food", false);
			cookCheckList.put("Completed Order", false);
			cookCheckList.put("Leaving", false);

			cookChecks.put(name, cookCheckList);
		}
	}

	private static boolean ifAny(HashMap<String, Boolean> checks, boolean anyWhat) { // Checks if any checks are
		Iterator<String> it = checks.keySet().iterator();
		while (it.hasNext()) {
			String checkName = it.next();
			boolean check = checks.get(checkName);
			if (anyWhat) {
				if (check) {
					return true;
				}
			} else {
				if (!check) {
					if (checkName != "Leaving") {
						return true;
					}
				}
			}
		}
		return false;
	}

	private static void updateEvents() {
		Iterator<SimulationEvent> iterator = Simulation.events.iterator();
		while (iterator.hasNext()) {
			SimulationEvent event = iterator.next();
			String type = "";
			if (event.cook != null) {
				type = "cook";
			} else if (event.customer != null) {
				type = "customer";
			} else {
				continue;
			}
			String name = "";
			switch (type) {
			case "cook":
				name = event.cook.toString();
				// Initialize if need be
				if (!cookEvents.containsKey(name)) {
					cookEvents.put(name, new ArrayList<SimulationEvent>());
				}
				cookEvents.get(name).add(event);
				break;
			case "customer":
				name = event.customer.toString();
				// Initialize if need be
				if (!customerEvents.containsKey(name)) {
					customerEvents.put(name, new ArrayList<SimulationEvent>());
				}
				customerEvents.get(name).add(event);
				break;
			default:
				return;
			}
		}
	}

	private static void checkEventOrder() {
		try {
			// Customer Events
			Iterator<String> it = customerEvents.keySet().iterator();
			while (it.hasNext()) {
				String name = it.next();
				// Check if they first Started
				check(customerEvents.get(name).get(0).event == SimulationEvent.EventType.CustomerStarting,
						name + " didn't start off by heading to Ratsies");

				HashMap<String, Boolean> checks = customerChecks.get(name);
				List<SimulationEvent> events = customerEvents.get(name);
				Iterator<SimulationEvent> eventIterator = events.iterator();
				while (eventIterator.hasNext()) {
					SimulationEvent event = eventIterator.next();
					switch (event.event) {
					case CustomerStarting:
						check(!ifAny(checks, true), name + " did something before leaving for Ratsies");
						checks.put("Starting", true);
						break;
					case CustomerEnteredRatsies:
						check(checks.get("Starting") == true, name + " entered Ratsies before they left for Ratsies");
						checks.put("Entered", true);
						break;
					case CustomerPlacedOrder:
						check(checks.get("Entered") == true, name + " placed an order before entering Ratsies");
						checks.put("Ordered", true);
						break;
					case CustomerReceivedOrder:
						check(checks.get("Ordered") == true, name + " received their order before they placed it");
						checks.put("Received Order", true);
						break;
					case CustomerLeavingRatsies:
						check(!ifAny(checks, false), name + " left before they completed every other event");
						checks.put("Leaving", true);
						break;
					default:
						check(false, name + " has an Invalid EventType");
					}
				}
			}

			Iterator<String> it2 = cookEvents.keySet().iterator();
			while (it2.hasNext()) {
				String name = it2.next();
				// Check if they first Started
				check(cookEvents.get(name).get(0).event == SimulationEvent.EventType.CookStarting,
						name + " didn't start off by reporting to work");

				HashMap<String, Boolean> checks = cookChecks.get(name);
				List<SimulationEvent> events = cookEvents.get(name);
				Iterator<SimulationEvent> eventIterator = events.iterator();
				int orderNum = 0;
				while (eventIterator.hasNext()) {
					SimulationEvent event = eventIterator.next();
					if (!(event.orderNumber == 0) && orderNum != event.orderNumber) {
						checks.put("Received Order", false);
						checks.put("Preparing Food", false);
						checks.put("Finished Food", false);
						checks.put("Completed Order", false);
					}
					orderNum = event.orderNumber;
					Iterator<String> checkIt = checks.keySet().iterator();
					switch (event.event) {
					case CookStarting:
						while (checkIt.hasNext()) {
							if (checks.get(checkIt.next())) {
								check(false, name + " left before they completed every other event");
							}
						}
						checks.put("Starting", true);
						break;
					case CookReceivedOrder:
						check(checks.get("Starting") == true,
								name + " received an order before they reported for work");
						checks.put("Received Order", true);
						break;
					case CookStartedFood:
						check(checks.get("Received Order") == true,
								name + " started to make food before they received an order");
						checks.put("Preparing Food", true);
						break;
					case CookFinishedFood:
						check(checks.get("Preparing Food") == true,
								name + " finished making food before they started to make it");
						checks.put("Finished Food", true);
						break;
					case CookCompletedOrder:
						if (!checks.get("Finished Food")) {
							System.out.println("here");
						}
						check(checks.get("Finished Food") == true,
								name + " completed order " + event.orderNumber + " before they finished the food");
						checks.put("Completed Order", true);
						break;
					case CookEnding:
						while (checkIt.hasNext()) {
							String key = checkIt.next();
							if (key == "Leaving") {
								continue;
							}
							if (!checks.get(key)) {
								check(false, name + " left before they completed every other event");
							}
						}
						checks.put("Leaving", true);
						break;
					default:
						check(false, name + " has an Invalid EventType");
					}
				}
			}
		} catch (InvalidSimulationException e) {
			return;
		}
	}

	private static boolean checkCapacity() {
		if (currentCustomers > 75) {
			return false;
		} else {
			return true;
		}
	}

	/**
	 * Validates the given list of events is a valid simulation. Returns true if the
	 * simulation is valid, false otherwise.
	 *
	 * @param events - a list of events generated by the simulation in the order
	 *               they were generated.
	 *
	 * @returns res - whether the simulation was valid or not
	 */

	public static boolean validateSimulation(List<SimulationEvent> events) {
		try {
			updateEvents();
			makeChecks();
			checkEventOrder();
			check(events.get(0).event == SimulationEvent.EventType.SimulationStarting,
					"Simulation didn't start with initiation event");
			check(events.get(events.size() - 1).event == SimulationEvent.EventType.SimulationEnded,
					"Simulation didn't end with termination event");
			Iterator<SimulationEvent> iterator = events.iterator();
			while (iterator.hasNext()) {
				SimulationEvent event = iterator.next();
				if (event.event == SimulationEvent.EventType.CustomerEnteredRatsies) { // Check if Ratsies is Full
					currentCustomers++;
					check(checkCapacity(), "Customer " + event.customer + " entered when Ratsies was full");
				} else if (event.event == SimulationEvent.EventType.CustomerLeavingRatsies) { // Customer left Ratsies
					currentCustomers--;
				}
			}

			/*
			 * In P2 you will write validation code for things such as: Should not have more
			 * eaters than specified Should not have more cooks than specified The Ratsie's
			 * capacity should not be exceeded The capacity of each machine should not be
			 * exceeded Eater should not receive order until cook completes it Eater should
			 * not leave Ratsie's until order is received Eater should not place more than
			 * one order Cook should not work on order before it is placed
			 */

			return true;
		} catch (InvalidSimulationException e) {
			return false;
		}

	}
}
