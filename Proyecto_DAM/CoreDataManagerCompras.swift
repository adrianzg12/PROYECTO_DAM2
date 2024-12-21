import Foundation
import CoreData

// Asegúrate de que este código esté dentro de Persistence.swift o en un archivo separado según tu estructura de proyecto.

struct CoreDataManagerCompras {
    
    static let shared = CoreDataManagerCompras()
    
    // Usamos el contexto compartido del PersistenceController
    private let context = PersistenceController.shared.viewContext
    
    // Función para guardar un artículo
    func guardarArticulo(nombre: String, cantidad: Int32, prioridad: String, notas: String?, categoria: String, tienda: String) throws {
        let nuevoArticulo = Articulo(context: context)
        nuevoArticulo.id = UUID()  // Asignamos un ID único
        nuevoArticulo.nombre = nombre
        nuevoArticulo.cantidad = cantidad
        nuevoArticulo.prioridad = prioridad
        nuevoArticulo.notas = notas
        nuevoArticulo.comprado = false  // Por defecto, el artículo no está comprado
        nuevoArticulo.categoria = categoria
        nuevoArticulo.tienda = tienda
        
        try context.save()  // Guardamos el contexto
    }
    
    // Función para cargar todos los artículos
    func cargarArticulos() -> [Articulo]? {
        let fetchRequest: NSFetchRequest<Articulo> = Articulo.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)  // Recuperamos todos los artículos
        } catch {
            print("Error al cargar artículos: \(error)")
            return nil
        }
    }
    
    // Función para eliminar un artículo
    func eliminarArticulo(articulo: Articulo) throws {
        context.delete(articulo)
        try context.save()  // Guardamos el contexto después de la eliminación
    }
    
    // Función para eliminar artículos seleccionados
    func eliminarArticulosSeleccionados(articulosSeleccionados: [Articulo]) throws {
        for articulo in articulosSeleccionados {
            context.delete(articulo)
        }
        try context.save()  // Guardamos el contexto después de las eliminaciones
    }
    
    // Función para marcar artículos seleccionados como comprados
    func marcarArticulosComprados(articulosSeleccionados: [Articulo]) throws {
        for articulo in articulosSeleccionados {
            articulo.comprado = true
        }
        try context.save()  // Guardamos el contexto después de marcar como comprados
    }
    
    // Función para filtrar artículos por categoría y tienda
    func filtrarArticulos(categoria: String?, tienda: String?) -> [Articulo]? {
        let fetchRequest: NSFetchRequest<Articulo> = Articulo.fetchRequest()
        var predicados: [NSPredicate] = []
        
        if let categoria = categoria {
            predicados.append(NSPredicate(format: "categoria == %@", categoria))
        }
        
        if let tienda = tienda {
            predicados.append(NSPredicate(format: "tienda == %@", tienda))
        }
        
        if !predicados.isEmpty {
            fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicados)  // Combinamos los predicados con AND
        }
        
        do {
            return try context.fetch(fetchRequest)  // Recuperamos los artículos filtrados
        } catch {
            print("Error al filtrar artículos: \(error)")
            return nil
        }
    }
}
