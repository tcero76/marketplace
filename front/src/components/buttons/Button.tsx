import { } from 'react'
import { ButtonProps } from '../../types'

const Button = ({btnType, label, icon, ...props}:ButtonProps) => {
    return (<button type="button"
                className={`btn btn-${btnType} py-2 rounded`}
                {...props}
                >{label && <span>{label}</span>}{icon && <span className={`bi bi-${icon}`}></span>}</button>
    )
}

export default Button