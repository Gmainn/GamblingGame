class SlotSymbol {
  final String id;
  final String glyph; // emoji for now; swap for an image asset path later
  final int weight; // higher = more common
  final double payout; // multiplier for 3-of-a-kind

  const SlotSymbol(this.id, this.glyph, this.weight, this.payout);

  bool get isRare => payout >= 10;
}
