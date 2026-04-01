'use client'

import { useEffect, useState } from 'react'
import LoginModal from '@/layout/LoginModal'
import { useSearchParams } from 'next/navigation';

export default function Page() {
  const searchParams = useSearchParams();
  const [challenge, setChallenge] = useState<string>('');
  useEffect(() => {
    const lc = searchParams.get('login_challenge');
    if (lc) {
      setChallenge(lc);
    }
  }, [searchParams]);
  return (
    <div className="flex relative w-full items-center justify-center p-6 md:p-10">
      <div className="w-full max-w-sm translate-y-[25%]">
        <LoginModal challenge={challenge}/>
      </div>
    </div>
  )
}