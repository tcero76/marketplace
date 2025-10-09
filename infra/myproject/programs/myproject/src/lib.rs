use anchor_lang::prelude::*;

declare_id!("6RTFvBwrNy3HNznUaB39B5TMvQGhwbodRUY7JuVVnnch");

#[program]
pub mod transfer_event {
    use super::*;
    pub fn send_sol(ctx: Context<SendSol>, amount: u64) -> Result<()> {
        let from = &ctx.accounts.from;
        let to = &ctx.accounts.to;

        msg!("Iniciando transferencia de {} lamports", amount);
        let ix = anchor_lang::solana_program::system_instruction::transfer(
            &from.key(),
            &to.key(),
            amount,
        );

        anchor_lang::solana_program::program::invoke(
            &ix,
            &[
                from.to_account_info(),
                to.to_account_info(),
                ctx.accounts.system_program.to_account_info(),
            ],
        )?;

        emit!(TransferEvent {
            sender: ctx.accounts.from.key(),
            receiver: ctx.accounts.to.key(),
            amount,
        });
        Ok(())
    }
}

#[derive(Accounts)]
pub struct SendSol<'info> {
    #[account(mut)]
    pub from: Signer<'info>,  // La cuenta que envía SOL
    #[account(mut)]
    pub to: SystemAccount<'info>,  // La cuenta que recibe SOL
    pub system_program: Program<'info, System>,
}

#[event]
pub struct TransferEvent {
    pub sender: Pubkey,
    pub receiver: Pubkey,
    pub amount: u64,
}

