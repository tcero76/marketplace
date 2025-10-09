import {} from 'react'

const Footer = () => {
    return (
        <footer className="footer mt-auto py-3 bg-light">
            <div className="col-md-4 d-flex align-items-center">
                <a href="/" className="mb-3 me-2 mb-md-0 text-body-secondary text-decoration-none lh-1" aria-label="Bootstrap">
                    <svg className="bi" width="30" height="24" aria-hidden="true">
                        <use xlinkHref="#bootstrap"></use>
                    </svg>
                </a>
                <span className="mb-3 mb-md-0 text-body-secondary">© 2025 Company, Inc</span>
            </div>
            <ul className="nav col-md-4 justify-content-end list-unstyled d-flex">
                <li className="ms-3">
                    <a className="text-body-secondary" href="#" aria-label="Instagram">
                        <svg className="bi" width="24" height="24" aria-hidden="true">
                            <use xlinkHref="#instagram"></use>
                        </svg>
                    </a>
                </li>
                <li className="ms-3">
                    <a className="text-body-secondary" href="#" aria-label="Facebook">
                        <svg className="bi" width="24" height="24">
                            <use xlinkHref="#facebook"></use>
                        </svg>
                    </a>
                </li>
            </ul>
        </footer>
    )
}

export default Footer