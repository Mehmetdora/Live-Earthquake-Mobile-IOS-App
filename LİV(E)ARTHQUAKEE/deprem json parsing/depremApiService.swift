//
//  depremApiService.swift
//  LİV(E)ARTHQUAKEE
//
//  Created by Mehmet Dora on 31.05.2023.
//

import Foundation



class depremApiParser {
    
    
    
    func getDepremData(url:String,completion:@escaping(DepremApiModel?)->()
    ){
        let URL = URL(string:url)!
        
        let dataTask = URLSession.shared.dataTask(with: URL) { (data,resp,err) in
            if err != nil{
                print("There is a problem while decoding data !")
                completion(nil)
            }
            if let data = data {
                let decoder = JSONDecoder()
                let veri = try? decoder.decode(DepremApiModel.self, from: data)
                if let veri = veri {
                    print("there is data")
                    completion(veri)
                }
            }
            
        }
        dataTask.resume()
        
    }
    
    
    func getTürkiyeDepremData(urll:String,completion:@escaping(DepremTürkiyeApiModel?)->()
    ){
        print("\(urll)--------------")
        let URL = URL(string: urll)!
        
            let dataTask = URLSession.shared.dataTask(with: URL ) { (data,resp,err) in
                        if err != nil{
                            print("There is a problem while decoding data !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
                            completion(nil)
                        }
                        if let data = data {
                            let decoder = JSONDecoder()
                            let veri = try? decoder.decode(DepremTürkiyeApiModel.self, from: data)
                            if let veri = veri {
                                print("there is data :)")
                                completion(veri)
                            }
                        }
                        
                    }
                    dataTask.resume()

        
        
        
    }
    
    
    
}
