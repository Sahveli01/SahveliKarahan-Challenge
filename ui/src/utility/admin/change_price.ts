import { Transaction } from "@mysten/sui/transactions";

export const changePrice = (packageId: string, listHeroId: string, newPriceInSui: string, adminCapId: string) => {
  const tx = new Transaction();

  // HATA 2 ve 3 DÜZELTİLDİ: Boşluklar silindi ve BigInt yerine Number kullanıldı
  const newPriceInMist = Number(newPriceInSui) * 1000000000;

  // HATA 1 DÜZELTİLDİ: 'target:' formatı yerine yeni format kullanıldı
  tx.moveCall({
    package: packageId,
    module: 'marketplace',
    function: 'change_the_price',
    arguments: [
      tx.object(adminCapId),
      tx.object(listHeroId),
      tx.pure.u64(newPriceInMist)
    ],
  });

  return tx;
};
