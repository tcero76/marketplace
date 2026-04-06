import { ForwardedRef, forwardRef, useImperativeHandle, useRef } from 'react'
import { ModalHtmlHandle, ModalHtmlProps } from '../../types';
import { Button } from "@/components/ui/button"
import {
  Dialog,
  DialogClose,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog"

const ModalHtml= forwardRef<ModalHtmlHandle, ModalHtmlProps>((
  {isHeader=false,textHeader,textBtnAccept,iconBtnAccept, onClickModal,
    children, open, setOpen},
    ref:ForwardedRef<ModalHtmlHandle>) => {
    const refModal = useRef<HTMLDivElement>(null);
    useImperativeHandle(ref, () => ({
      open: () => setOpen(true),
      close: () => setOpen(false),
    }), []);
    return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogContent  className="bg-white">
        <DialogHeader>
          <DialogTitle>Sticky Footer</DialogTitle>
          <DialogDescription>
            This dialog has a sticky footer that stays visible while the content
            scrolls.
          </DialogDescription>
        </DialogHeader>
        <div className="-mx-4 no-scrollbar max-h-[50vh] overflow-y-auto px-4">
          {children}
        </div>
        <DialogFooter>
          <DialogClose asChild>
            <Button variant="outline">Close</Button>
          </DialogClose>
          <Button type="submit"
            variant="outline"
            onClick={onClickModal}
          >Save changes</Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
    )
})

export default ModalHtml