package maui.model;

import com.thoughtworks.xstream.XStream;
import com.thoughtworks.xstream.io.xml.StaxDriver;
import smile.classification.RandomForest;
import smile.data.AttributeDataset;
import smile.data.NominalAttribute;
import smile.data.parser.DelimitedTextParser;
import smile.math.Math;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.ParseException;
import java.util.Arrays;
import java.util.stream.IntStream;

/**
 * This
 *
 */
public class ModelGenerator {

    private static String DEFAULT_DATA_DIRECTORY = "/src/main/resources/";
    private static String DEFAULT_MODEL_DIRECTORY = "/src/main/resources/";
    private static final String RESPONSE_VARNAME = "no2";
    private static final int RESPONSE_VARINDEX = 14;
    private static final String FILE_DELIMITER = ",";

    private static int[] stations = new int[]{4, 8, 11, 16, 17, 18, 24, 27, 35, 36, 38, 39, 40, 47, 48, 49, 50, 54, 55, 56,
    57, 58, 59, 60};

    public static void main(String[] args) throws IOException, ParseException {
        // data directory
        if(args[0] != null){
            DEFAULT_DATA_DIRECTORY = args[0];
        }

        if(args[1] != null){
            DEFAULT_MODEL_DIRECTORY = args[1];
        }

        for(int station : stations) {
            Path filePath = Paths.get(DEFAULT_DATA_DIRECTORY + station + "/data_station_" + station);
            writeRandomForestModelToXML(filePath);
        }
//        try(Stream<Path> fileCursor = Files.walk(Paths.get(DEFAULT_DATA_DIRECTORY))){
//
//        } catch (IOException e) {
//            e.printStackTrace();
//        }
    }

    private static void writeRandomForestModelToXML(Path filePath) throws IOException, ParseException {
        DelimitedTextParser parser = new DelimitedTextParser();
        parser.setIgnoredColumns(Arrays.asList(new Integer[]{0}));
        parser.setColumnNames(true);
        parser.setDelimiter(FILE_DELIMITER);
        NominalAttribute att = new NominalAttribute(RESPONSE_VARNAME);
        AttributeDataset data = null;
        try {
            parser.setResponseIndex(att, RESPONSE_VARINDEX);
            data = parser.parse(filePath.toUri());
        } catch (ParseException e) {
            parser.setResponseIndex(att, 13);
            data = parser.parse(filePath.toUri());
        }

        double[][] datax = data.toArray(new double[data.size()][]);
        int[] datay = data.toArray(new int[data.size()]);
        int eightyPercentLimit = java.lang.Math.round(data.size() * 0.8f);
        double[][] trainx = Math.slice(datax, IntStream.range(0, eightyPercentLimit).toArray());
        int[] trainy = Math.slice(datay, IntStream.range(0, eightyPercentLimit).toArray());
        RandomForest forest = new RandomForest(data.attributes(), trainx, trainy, 500);
        XStream xstream = new XStream(new StaxDriver());
        byte[] modelXML = xstream.toXML(forest).getBytes();
        String outputFilename = DEFAULT_MODEL_DIRECTORY + "model_station_" + filePath.getFileName()
                .toString().split("data_station_")[1] + ".xml";
        OutputStream os = new FileOutputStream(outputFilename);
        os.write(modelXML);
        os.close();
    }
}
