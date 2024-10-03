import 'dart:io';

class Item {
  String name = "test";
  double price = 0.0;

  Item(this.name, this.price);

  String displayItem() => "Name: $name \tPrice: \$$price";
}

class ItemStock {
  Item item;
  int stock = 0;

  ItemStock(this.item, this.stock);

  bool isInStock() => (stock > 0);
}

class VendingMachine {
  List<ItemStock> items = [];
  double balance = 0.0;

  void addItem(Item item, int stock) {
    this.items.add(new ItemStock(item, stock));
  }

  ItemStock selectItem(String itemName) {
    ItemStock chosen = items.firstWhere((itemStock) => itemStock.item.name == itemName , orElse: null);
    if (chosen.stock > 0) 
      print("Price: \$${chosen.item.price}");
    
    return chosen;
  }

  void insertMoney(double amount) => balance += amount;

  String dispenseItem(String itemName) {
    ItemStock chosen = selectItem(itemName);
    double price = chosen.item.price; 
    if (chosen.stock == 0)
      return "Out of Stock";
    else if (price > balance)
      return "Insuffecient funds";
    else {
      balance -= price;
      chosen.stock--;
      return "Item dispensed. Enjoy:)";
    }
  }

  double getChange() => balance;

  void refillStock(String itemName, int addedStock) {    //Bonus 1
    ItemStock chosen = selectItem(itemName);
    chosen.stock += addedStock;
    print("Added stock successfully");
  }

  void displayStock() {     //Bonus 2
    for (ItemStock itemStock in items) {
      print("${itemStock.item.displayItem()} \t(Stock: ${itemStock.stock})");
    }
  }

  void applyDiscount(String itemName, double discount) {    //Bonus 3
    ItemStock chosen = selectItem(itemName);
    double price = chosen.item.price; 
    chosen.item.price -= price * discount;
    print("applied discount. New price: ${chosen.item.price}");
  }
}


double inputDouble() {     //Check the input to make sure it is a double
  String input = stdin.readLineSync() as String;
  double? number = double.tryParse(input);
  while (number == null) {
    print("Try again");
    input = stdin.readLineSync() as String;
    number = double.tryParse(input);
  }
  return number;
}

void main() {
  VendingMachine machine = new VendingMachine();

  machine.addItem(Item("Soda", 2.5), 10);
  machine.addItem(Item("Chips", 1.5), 5);
  machine.addItem(Item("Candy", 1.0), 0);

  machine.applyDiscount("Soda", 50 / 100);

  print("\nWelcome to the Vending Machine!\n");

  print("Items Available:");
  machine.displayStock();

  stdout.write("\nInsert money: ");
  machine.balance = inputDouble();

  do {
    stdout.write("\nSelect item: ");
    String input = stdin.readLineSync() as String;
    print(machine.dispenseItem(input));
    print("Remaining balance: \$${machine.getChange()}");

    stdout.write("\nDo you want another item? (yes/no): ");
    input = stdin.readLineSync() as String;
    if (input == "no") {
      print("Returning change: \$${machine.getChange()}");
      print("Thank you for using the vending machine!\n");
      break;
    }
  } while (true);
}