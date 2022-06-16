class ProvisionedThroughput {
  int? numberOfDecreasesToday;
  int writeCapacityUnits;
  int readCapacityUnits;

  ProvisionedThroughput(this.writeCapacityUnits,
      this.readCapacityUnits, {this.numberOfDecreasesToday});
}
