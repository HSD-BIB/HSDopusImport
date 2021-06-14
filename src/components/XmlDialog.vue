<template>
  <q-dialog
    :model-value="modelValue"
    persistent
    no-esc-dismiss
    no-backdrop-dismiss
    @update:modelValue="$emit('update:modelValue', $event)"
  >
    <q-card style="width: 700px; max-width: 80vw;">
      <q-item>
        <q-item-section>
          <q-item-label>{{ $t('transformation.title') }}</q-item-label>
          <q-item-label caption>{{ $t('transformation.subtitle') }}</q-item-label>
        </q-item-section>
      </q-item>

      <q-separator />

      <q-input
        style="max-height: 70vh;"
        class="scroll q-px-md"
        type="textarea"
        readonly
        :model-value="xml"
        rows="25"
      />

      <q-separator />

      <q-card-actions>
        <q-btn
          :label="$t('form.download')"
          color="primary"
          class="q-ml-sm"
          @click="onDownload"
        />
        <q-space />
        <q-btn
          :label="$t('form.cancel')"
          color="primary"
          flat
          class="q-ml-sm"
          @click="$emit('close')"
        />
      </q-card-actions>
    </q-card>
  </q-dialog>
</template>

<script>
import { saveAs } from 'file-saver';
import { createZip } from 'src/helpers';

export default {
  props: {
    modelValue: {
      type: Boolean,
      required: true,
    },
    xml: {
      type: String,
      required: true,
    },
  },
  emits: ['close', 'update:modelValue'],
  setup(props) {
    const onDownload = () => {
      createZip(props.xml)
        .then((content) => {
          saveAs(content, 'opos.zip');
        });
    };

    return {
      onDownload,
    };
  },
};
</script>
