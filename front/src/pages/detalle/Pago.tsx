import { useEffect, useState } from 'react'
import { Keypair, PublicKey, SystemProgram, LAMPORTS_PER_SOL, Transaction, VersionedTransaction } from "@solana/web3.js";
import { Buffer } from "buffer";
import  { type Idl, Program, setProvider, AnchorProvider, web3, Wallet } from "@coral-xyz/anchor";
import BN from 'bn.js';
import idl from './../../assets/idl/transfer_event.json'
import { useAuthDispatch } from '../../store/hooks.tsx';
import getUserApi from '../../http/HttpFactory.ts';
import Button from '../../components/buttons/Button.tsx';

declare global {

  interface Window {
    solana: {
      Buffer: typeof Buffer;
      publicKey: PublicKey;
      keyPair:Keypair;
      isPhantom: boolean;
      connect: () => Promise<Wallet>;
      disconnect: () => Promise<void>;
      signTransaction: <T extends Transaction | VersionedTransaction>(tx: T) => Promise<T>;
      signAllTransactions: <T extends Transaction | VersionedTransaction>(txs: T[]) => Promise<T[]>;
    
    };
  }
}
let wallet:Wallet;
let program:Program;
const Pago = () => {
  const dispatch = useAuthDispatch();
  window.Buffer = Buffer;
  const [rec ] = useState<string>("AjBsn7Ks3sfZA58LHHYG5ChxkSkC6eCSythhT7NkgMEQ")
  const [sol, setSol ] = useState<number>(0.01)
  useEffect(() => {
    dispatch(getUserApi().getAuthenticated())
    const connectWallet = async () => {
      if (!window.solana) {
        throw new Error("No Solana wallet found");
      }
      wallet = await window.solana.connect();
      const connection = new web3.Connection("https://api.devnet.solana.com");
      const provider = new AnchorProvider(
        connection,
        {
          publicKey: wallet.publicKey,
          signTransaction: window.solana.signTransaction,
          signAllTransactions: window.solana.signAllTransactions,
        },
        { preflightCommitment: "confirmed" }
      );
      setProvider(provider);
      program = new Program(idl as Idl, provider);
    }
    connectWallet()
  },[])
  const sendSol = async () => {
      if(!window.solana) {
        return
      }
      if (!window.solana.isPhantom || !wallet.publicKey) {
        console.error("Por favor, conecta tu wallet primero");
        return;
      }
      try {
        const receiver = new PublicKey(rec);
        const amount = new BN(sol * LAMPORTS_PER_SOL);
        const tx = await program.methods
          .sendSol(amount)
          .accounts({
            from: wallet,
            to: receiver,
            systemProgram: SystemProgram.programId,
          })
          .rpc();
        console.log("Transacción exitosa, firma:", tx);
      } catch (error) {
        console.error("Error en la transacción:", error);
      }
  };
  const onChangeSol = (e: React.ChangeEvent<HTMLInputElement>) => {
    if(!e.target.value) {
      setSol(0)
      return
    }
    const regex = /^\d*\.?\d*$/;
    if(regex.test(e.target.value)) {
      setSol(parseFloat(e.target.value))
    }
  }
  return (
    <>
      <h1>Pago</h1>
      <label>Wallet Destino: {rec}</label>
      <input value={sol} onChange={e=>onChangeSol(e)}></input>
      <br/>
      <Button btnType="primary" label={`Enviar ${sol} SOL`}
        onClick={sendSol}
        />
    </>
  )
}
export default Pago