import { ComponentPropsWithoutRef } from 'react'

export type ButtonProps = {
    btnType:string
    label:string
} & ComponentPropsWithoutRef<'button'>

const Button = ({btnType, label, ...props}:ButtonProps) => {
    return (<button type="button"
                className={`btn btn-${btnType} py-2 rounded`}
                {...props}
                >{label}</button>
    )
}

export default Button