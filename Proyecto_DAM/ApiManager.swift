import Alamofire
import Foundation

class ApiManager {
    
    static let shared = ApiManager()
    
    func fetchCategorias(completion: @escaping ([String]?, Error?) -> Void) {
        let url = "http://localhost:9090/api/categories"
        AF.request(url).responseJSON { response in
            switch response.result {
            case .success(let json):
                print("Categorias response: \(json)")
                
                if let jsonArray = json as? [[String: Any]] {
                    let nombresCategorias = jsonArray.compactMap { categoria -> String? in
                        return categoria["nombre"] as? String
                    }
                    completion(nombresCategorias, nil)
                } else {
                    completion(nil, NSError(domain: "APIError", code: 100, userInfo: [
                        NSLocalizedDescriptionKey: "La respuesta no es un array de objetos de categorías. Respuesta: \(json)"
                    ]))
                }
                
            case .failure(let error):
                completion(nil, error)
            }
        }
    }

    
    func fetchTiendas(completion: @escaping ([String]?, Error?) -> Void) {
        let url = "http://localhost:9090/api/tiendas"
        AF.request(url).responseJSON { response in
            switch response.result {
            case .success(let json):
                print("Tiendas response: \(json)")
                
                if let jsonArray = json as? [[String: Any]] {
                    let nombresTiendas = jsonArray.compactMap { tienda -> String? in
                        return tienda["nombre"] as? String
                    }
                    completion(nombresTiendas, nil)
                } else {
                    completion(nil, NSError(domain: "APIError", code: 100, userInfo: [
                        NSLocalizedDescriptionKey: "La respuesta no es un array de objetos de tiendas. Respuesta: \(json)"
                    ]))
                }
                
            case .failure(let error):
                completion(nil, error)
            }
        }
    }

}
