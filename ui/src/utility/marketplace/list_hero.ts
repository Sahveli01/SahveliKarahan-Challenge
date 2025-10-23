import { Transaction } from "@mysten/sui/transactions";

export const listHero = (
  packageId: string,
  heroId: string,
  priceInSui: string,
) => {
  const tx = new Transaction();

  const priceInMist = Number(priceInSui) * 1000000000;

  tx.moveCall({
  package: packageId,
  module: 'marketplace',
  function: 'list_hero',
  arguments: [
    tx.object(heroId),
    tx.pure.u64(priceInMist)
  ],
});

    return tx;

}
