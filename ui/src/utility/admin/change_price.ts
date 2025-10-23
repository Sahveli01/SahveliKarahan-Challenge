import { Transaction } from "@mysten/sui/transactions";

export const changePrice = (packageId: string, listHeroId: string, newPriceInSui: string, adminCapId: string) => {
  const tx = new Transaction();

  // 1. "0.04" gibi bir ondalıklı string'i önce Number'a çevirip MIST ile çarpıyoruz
  //    (Boşlukları olmayan 1000000000 kullanıyoruz)
  const priceAsNumber = Number(newPriceInSui) * 1000000000;

  // 2. Bu büyük sayıyı, hata olmasın diye BigInt'e çeviriyoruz
  const newPriceInMist = BigInt(priceAsNumber);

  // 3. 'target:' formatı yerine yeni formatı kullanıyoruz
  tx.moveCall({
    package: packageId,
    module: 'marketplace',
    function: 'change_the_price',
    arguments: [
      tx.object(adminCapId),
      tx.object(listHeroId),
      // 4. tx.pure.u64 fonksiyonuna BigInt'i metin (string) olarak veriyoruz.
      //    Bu, en güvenli yöntemdir.
      tx.pure.u64(newPriceInMist.toString())
    ],
  });

  return tx;
};
