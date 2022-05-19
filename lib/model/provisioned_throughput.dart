class ProvisionedThroughput {
  int numberOfDecreasesToday;
  int writeCapacityUnits;
  int readCapacityUnits;

  ProvisionedThroughput(this.numberOfDecreasesToday, this.writeCapacityUnits,
      this.readCapacityUnits);
}
