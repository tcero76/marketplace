// import { useEffect, useState } from 'react'
// import { useSearchParams } from "react-router-dom";
// import getUserApi  from "../../http/HttpFactory.ts"
// import { SearchPosts } from '../../types/index.ts';
// import { AxiosResponse } from 'axios';
// import { IndexRange, ListRowProps } from 'react-virtualized';
// import { useAuthDispatch } from '../../store/hooks.tsx'

// export default function Search() {
//   const dispatch = useAuthDispatch();
//   const [searchParams] = useSearchParams();
//   const search = searchParams.get('query') || '';
//   useEffect(() => {
//     dispatch(getUserApi().getAuthenticated())
//     if(!search) return;
//     getUserApi().searchPosts(search).then(res => {
//       setPosts(prev => {
//         return {
//           ...prev,
//           items: res.data
//         }
//       })
//     })
//   }, [search])
//     const [posts, setPosts] = useState<SearchPosts[]>([]);
//     const getPosting = (indexRange:IndexRange):Promise<void> => {
//       return getUserApi().searchPosts(search)
//             .then((res:AxiosResponse<SearchPosts[]>) => {
//               if(res.data) {
//                 setPosts(prev => {
//                   return {
//                     ...prev,
//                     items: res.data
//                   }
//                 })
//               }
//             })
//       }
//     const rowRenderer = ({ key, index, style }:ListRowProps) => {
//           const post = posts.items[index];
//           return (
//             <div className="row mb-3 text-center">
//               <div className="col-sm-4 themed-grid-col">
//                 <div className="card">
//                   <div className="card-body">
//                     <h5 className="card-title">{post.rank}</h5>
//                     <p className="card-text">{post.descripcion}</p>
//                     <p className="card-text">{post.id}</p>
//                   </div>
//                 </div>
//               </div>
//               <div className="col-sm-4 themed-grid-col">
//                 <div className="card">
//                   <div className="card-body">
//                     <h5 className="card-title">{post.rank}</h5>
//                     <p className="card-text">{post.descripcion}</p>
//                     <p className="card-text">{post.id}</p>
//                   </div>
//                 </div>
//               </div>
//               <div className="col-sm-4 themed-grid-col">
//                 <div className="card">
//                   <div className="card-body">
//                     <h5 className="card-title">{post.rank}</h5>
//                     <p className="card-text">{post.descripcion}</p>
//                     <p className="card-text">{post.id}</p>
//                   </div>
//                 </div>
//               </div>
//             </div>
//           )
//           }
//   return (
//     <div>
//       {/* <Virtualizer<SearchPosts> getItems={getPosting} items={posts} rowRenderer={rowRenderer}/> */}
//     </div>
//   )
// }