import { ComponentPropsWithoutRef } from "react"

export type ButtonProps = {
    btnType:string
    label?:string
    icon?:string
} & ComponentPropsWithoutRef<'button'>