import SwiftUI

struct ResumenComprasView: View {
    @FetchRequest var articulos: FetchedResults<Articulo>

    init() {
        self._articulos = FetchRequest(
            entity: Articulo.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Articulo.nombre, ascending: true)],
            predicate: nil // No necesitamos un filtro aquí
        )
    }

    var body: some View {
        VStack(spacing: 20) {
            // Título con tamaño de letra reducido y sin padding horizontal
            Text("Resumen de Compras")
                .font(.title) // Tamaño más pequeño
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .padding(.top) // Sólo se mantiene el padding superior

            // Sección de Totales
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "cart.fill")
                        .foregroundColor(.blue)
                    Text("Total de artículos: \(articulos.count)")
                        .font(.title2)
                        .fontWeight(.semibold)
                }

                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("Artículos comprados: \(articulos.filter { $0.comprado }.count)")
                        .font(.title2)
                        .fontWeight(.semibold)
                }

                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.orange)
                    Text("Artículos pendientes: \(articulos.filter { !$0.comprado }.count)")
                        .font(.title2)
                        .fontWeight(.semibold)
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 15).fill(Color.gray.opacity(0.1)))
            .padding(.horizontal, 0) // Eliminamos el padding horizontal

            // Desglose por categoría
            VStack(alignment: .leading, spacing: 12) {
                Text("Desglose por categoría:")
                    .font(.title2)
                    .fontWeight(.semibold)

                ForEach(getCategorias(), id: \.self) { categoria in
                    let categoriaArticulos = articulos.filter { $0.categoria == categoria }
                    let categoriaComprados = categoriaArticulos.filter { $0.comprado }.count
                    let categoriaPendientes = categoriaArticulos.filter { !$0.comprado }.count
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("\(categoria):")
                                .font(.headline)
                                .fontWeight(.bold)
                            Spacer()
                            Text("Comprados: \(categoriaComprados) | Pendientes: \(categoriaPendientes)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.blue))
                    }
                    .padding(.horizontal, 0) // Eliminamos el padding horizontal
                }
            }
            .padding(.top)

            Spacer()
        }
        .padding()
        .background(Color(UIColor.systemBackground))
    }

    // Obtener todas las categorías
    func getCategorias() -> [String] {
        let categorias = Set(articulos.compactMap { $0.categoria })
        return Array(categorias)
    }
}
