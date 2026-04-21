import { FC } from 'react'
import { ModalHtmlProps } from '../../types';
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
import { useMediaQuery } from '@/hooks/use-media-query';
import { Drawer, DrawerClose, DrawerContent, DrawerDescription, DrawerFooter, DrawerHeader, DrawerTitle, DrawerTrigger } from '../ui/drawer';

const ModalHtml:FC<ModalHtmlProps>= ({
    isHeader=false,textHeader,textBtnAccept,
    iconBtnAccept, onClickModal,
    children, open, setOpen
  }) => {
    const isDesktop = useMediaQuery("(min-width: 768px)")
    if(isDesktop) {
      return (
      <Dialog open={open}
        onOpenChange={(nextOpen) => {
          if (nextOpen !== open) {
            setOpen(nextOpen);
          }
        }}>
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
    } else {
      return (
         <Drawer open={open} onOpenChange={setOpen}>
          <DrawerContent className="bg-white">
            <DrawerHeader className="text-left">
              <DrawerTitle>Edit profile</DrawerTitle>
              <DrawerDescription>
                Make changes to your profile here. Click save when you&apos;re done.
              </DrawerDescription>
            </DrawerHeader>
              {children}
            <DrawerFooter className="pt-2">
              <Button type="submit"
                variant="outline"
                onClick={onClickModal}
              >Save changes</Button>
              <DrawerClose asChild>
                <Button variant="outline">Cancel</Button>
              </DrawerClose>
            </DrawerFooter>
          </DrawerContent>
        </Drawer>
      )
    }
}

export default ModalHtml