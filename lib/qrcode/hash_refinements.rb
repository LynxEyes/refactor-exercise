module QRCode
  module HashRefinements
    refine Hash do
      def slice(*slice_keys)
        slice_keys.each_with_object({}) do |key, hash|
          hash[key] = self[key] if key?(key)
        end
      end
    end
  end
end
